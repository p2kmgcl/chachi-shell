use crate::util::{notify, tmp};
use chrono::{Local, Timelike};
use std::{env, time::Duration};

const FILE_DURATION_IN_SECS: u64 = 1800;
const SIGNS_FILE_NAME: &str = "woffu-signs";
const PRESENCE_FILE_NAME: &str = "woffu-presence";

pub fn toggle() {
    let notification_id = notify::send("Updating woffu sign status...", 0);
    let client = reqwest::blocking::Client::new();
    let token = env::var("WOFFU_TOKEN").expect("WOFFU_TOKEN env variable");
    let user_id = env::var("WOFFU_USER_ID").expect("WOFFU_USER_ID env variable");

    client
        .post("https://liferay.woffu.com/api/svc/signs/signs")
        .header("Content-Type", "application/json;charset=UTF-8")
        .bearer_auth(token)
        .body(format!(
            "{{\"UserId\":{},\"DeviceId\":\"WebApp\"}}",
            user_id
        ))
        .send()
        .expect("woffu server should be available");

    tmp::expire_file(SIGNS_FILE_NAME, 0);
    tmp::expire_file(PRESENCE_FILE_NAME, 0);
    notify::update(notification_id, "Woffu sign status updated.", 1000);
}

pub fn get_status() {
    let (is_sign_in, duration_worked_today) = {
        tmp::expire_file(SIGNS_FILE_NAME, FILE_DURATION_IN_SECS);

        let woffu_signs = tmp::read_json(SIGNS_FILE_NAME).unwrap_or_else(|_| {
            let client = reqwest::blocking::Client::new();
            let token = env::var("WOFFU_TOKEN").expect("WOFFU_TOKEN env variable");

            let updated_json = client
                .get("https://liferay.woffu.com/api/signs/slots")
                .header("Content-Type", "application/json;charset=UTF-8")
                .bearer_auth(token)
                .send()
                .expect("woffu server should be available")
                .json()
                .expect("response should be a json");

            tmp::write_json(SIGNS_FILE_NAME, &updated_json)
                .expect(format!("{} file should be updated", SIGNS_FILE_NAME).as_str());

            updated_json
        });

        let mut duration: Duration = Duration::new(0, 0);
        let mut last_sign_in: Option<Duration> = Option::None;

        for sign in woffu_signs
            .as_array()
            .expect("response json should be an array")
        {
            let sign_object = sign.as_object().expect("each sign should be an object");
            let sign_in = sign_object.get("In").expect("'In' property should exist");
            let sign_out = sign_object.get("Out").expect("'Out' property should exist");

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
            let token = env::var("WOFFU_TOKEN").expect("WOFFU_TOKEN env variable");
            let user_id = env::var("WOFFU_USER_ID").expect("WOFFU_USER_ID env variable");

            let updated_json = client
                .get(format!("https://liferay.woffu.com/api/users/{}/diaries/presence/summary?calculateYearHours=false", user_id))
                .header("Content-Type", "application/json;charset=UTF-8")
                .bearer_auth(token)
                .send()
                .expect("woffu server should be available")
                .json()
                .expect("response should be a json");

            tmp::write_json(PRESENCE_FILE_NAME, &updated_json)
                .expect(format!("{} file should be updated", PRESENCE_FILE_NAME).as_str());

            return updated_json;
        });

        let weekly_entry = woffu_presence
            .as_array()
            .expect("response should be an array")
            .get(0)
            .expect("response should not be empty")
            .as_object()
            .expect("each entry should be an object");

        let hours_worked = weekly_entry
            .get("HoursWorked")
            .expect("'HoursWorked' property should exist")
            .as_f64()
            .expect("'HoursWorked' property should be a number");

        let hours_to_work = weekly_entry
            .get("HoursToWork")
            .expect("'HoursToWork' property should exist")
            .as_f64()
            .expect("'HoursToWork' property should be a number");

        Duration::new(((hours_to_work - hours_worked) * 3600.0) as u64, 0)
    };

    println!(
        "{} {} / {}",
        if is_sign_in { "⚒" } else { "❀" },
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
        .expect("entry should be an object")
        .get("ShortTrueTime")
        .expect("'ShortTrueTime' property should exist")
        .as_str()
        .expect("'ShortTrueTime' property should be a string")
        .to_string()
        .split(":")
        .map(|s| {
            s.parse::<u64>()
                .expect("'ShortTrueTime' should follow HH:MM:ss format")
        })
        .collect();

    Duration::new(parts[0] * 3600 + parts[1] * 60 + parts[2], 0)
}
