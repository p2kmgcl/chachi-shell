use crate::util::{notify, tmp};
use chrono::{Local, Timelike};
use std::{env, time::Duration};

const FILE_DURATION_IN_SECS: u64 = 1800;
const SIGNS_FILE_NAME: &str = "woffu-signs";
const PRESENCE_FILE_NAME: &str = "woffu-presence";

pub fn toggle() {
    let mut notification = notify::send()
        .body("Updating woffu sign status...")
        .timeout(0)
        .show()
        .unwrap();

    let client = reqwest::blocking::Client::new();
    let token = env::var("WOFFU_TOKEN").unwrap();
    let user_id = env::var("WOFFU_USER_ID").unwrap();

    client
        .post(format!("https://liferay.woffu.com/api/svc/signs/signs"))
        .header("Content-Type", "application/json;charset=UTF-8")
        .bearer_auth(token)
        .body(format!(
            "{{\"UserId\":{},\"DeviceId\":\"WebApp\"}}",
            user_id
        ))
        .send()
        .unwrap();

    tmp::expire_file(SIGNS_FILE_NAME, 0);
    tmp::expire_file(PRESENCE_FILE_NAME, 0);

    notification
        .body("Woffu sign status updated.")
        .timeout(1000);

    std::thread::sleep(Duration::from_secs(1));
    notification.update();
}

pub fn get_status() {
    let (is_sign_in, duration_worked_today) = {
        tmp::expire_file(SIGNS_FILE_NAME, FILE_DURATION_IN_SECS);

        let woffu_signs = tmp::read_json(SIGNS_FILE_NAME).unwrap_or_else(|_| {
            let client = reqwest::blocking::Client::new();
            let token = env::var("WOFFU_TOKEN").unwrap();

            let updated_json = client
                .get("https://liferay.woffu.com/api/signs/slots")
                .header("Content-Type", "application/json;charset=UTF-8")
                .bearer_auth(token)
                .send()
                .and_then(|response| response.json())
                .unwrap();

            tmp::write_json(SIGNS_FILE_NAME, &updated_json).unwrap();

            updated_json
        });

        let mut duration: Duration = Duration::new(0, 0);
        let mut last_sign_in: Option<Duration> = Option::None;

        for sign in woffu_signs.as_array().unwrap() {
            let sign_object = sign.as_object().unwrap();
            let sign_in = sign_object.get("In").unwrap();
            let sign_out = sign_object.get("Out").unwrap();

            if !sign_in.is_null() {
                last_sign_in = Option::Some(sign_entry_to_duration(sign_in));
            }

            if !sign_out.is_null() && last_sign_in.is_some() {
                let sign_in_value = last_sign_in.unwrap();
                let sign_out_value = sign_entry_to_duration(sign_out);
                duration = duration + (sign_out_value - sign_in_value);
                last_sign_in = Option::None;
            }
        }

        if last_sign_in.is_some() {
            let now = Local::now();

            let now_duration = Duration::new(
                (now.hour() * 3600 + now.minute() * 60 + now.second()) as u64,
                0,
            );

            duration = duration + (now_duration - last_sign_in.unwrap());
        }

        (last_sign_in.is_some(), duration)
    };

    let duration_pending_in_week = {
        tmp::expire_file(PRESENCE_FILE_NAME, FILE_DURATION_IN_SECS);

        let woffu_presence = tmp::read_json(PRESENCE_FILE_NAME).unwrap_or_else(|_| {
            let client = reqwest::blocking::Client::new();
            let token = env::var("WOFFU_TOKEN").unwrap();
            let user_id = env::var("WOFFU_USER_ID").unwrap();

            let updated_json = client
                .get(format!("https://liferay.woffu.com/api/users/{}/diaries/presence/summary?calculateYearHours=false", user_id))
                .header("Content-Type", "application/json;charset=UTF-8")
                .bearer_auth(token)
                .send()
                .and_then(|response| response.json())
                .unwrap();

            tmp::write_json(PRESENCE_FILE_NAME, &updated_json).unwrap();
            return updated_json;
        });

        let weekly_entry = woffu_presence
            .as_array()
            .unwrap()
            .get(0)
            .unwrap()
            .as_object()
            .unwrap();

        let hours_worked = weekly_entry.get("HoursWorked").unwrap().as_f64().unwrap();
        let hours_to_work = weekly_entry.get("HoursToWork").unwrap().as_f64().unwrap();

        Duration::new(((hours_to_work - hours_worked) * 3600.0) as u64, 0)
    };

    println!(
        "{} {} / {}",
        if is_sign_in { "💪" } else { "🏖️" },
        format_duration(duration_worked_today),
        if duration_worked_today > duration_pending_in_week {
            format!(
                "+{}",
                format_duration(duration_worked_today - duration_pending_in_week)
            )
        } else {
            format!(
                "-{}",
                format_duration(duration_pending_in_week - duration_worked_today)
            )
        },
    );
}

fn format_duration(duration: Duration) -> String {
    let duration_secs = duration.as_secs();
    let hours = duration_secs / 3600;
    let minutes = (duration_secs / 60) % 60;

    format!("{:02}:{:02}", hours, minutes)
}

fn sign_entry_to_duration(entry: &serde_json::Value) -> Duration {
    let parts: Vec<u64> = entry
        .as_object()
        .unwrap()
        .get("ShortTrueTime")
        .unwrap()
        .as_str()
        .unwrap()
        .to_string()
        .split(":")
        .map(|s| s.parse::<u64>().unwrap())
        .collect();

    Duration::new(parts[0] * 3600 + parts[1] * 60 + parts[2], 0)
}
