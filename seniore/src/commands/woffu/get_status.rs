use super::{
    format_duration, sign_entry_to_duration, FILE_DURATION_IN_SECS, PRESENCE_FILE_NAME,
    SIGNS_FILE_NAME,
};
use crate::util::runnable::Runnable;
use crate::util::tmp::{expire_file, read_json, write_json};
use chrono::{Local, Timelike};
use clap::Parser;
use reqwest::blocking::Client;
use std::env;
use std::time::Duration;

/// Get current status.
#[derive(Parser)]
pub struct Command {}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        let (is_sign_in, duration_worked_today) = {
            expire_file(SIGNS_FILE_NAME, FILE_DURATION_IN_SECS);

            let woffu_signs = read_json(SIGNS_FILE_NAME).unwrap_or_else(|| {
                let client = Client::new();
                let token = env::var("WOFFU_TOKEN").expect("WOFFU_TOKEN env variable");

                let updated_json = client
                    .get("https://liferay.woffu.com/api/signs/slots")
                    .header("Content-Type", "application/json;charset=UTF-8")
                    .bearer_auth(token)
                    .send()
                    .expect("woffu server should be available")
                    .json()
                    .expect("response should be a json");

                write_json(SIGNS_FILE_NAME, &updated_json);
                updated_json
            });

            let mut duration: Duration = Duration::new(0, 0);
            let mut maybe_last_sign_in: Option<Duration> = None;

            for sign in woffu_signs.as_array().unwrap_or_else(|| {
                panic!(
                    "response json should be an array, but it is {:}",
                    woffu_signs
                )
            }) {
                let sign_object = sign.as_object().expect("each sign should be an object");
                let sign_in = sign_object.get("In").expect("'In' property should exist");
                let sign_out = sign_object.get("Out").expect("'Out' property should exist");

                if !sign_in.is_null() {
                    maybe_last_sign_in = Some(sign_entry_to_duration(sign_in));
                }

                if !sign_out.is_null() && maybe_last_sign_in.is_some() {
                    let sign_in_value = maybe_last_sign_in.unwrap();
                    let sign_out_value = sign_entry_to_duration(sign_out);
                    duration += sign_out_value - sign_in_value;
                    maybe_last_sign_in = None;
                }
            }

            if let Some(last_sign_in) = maybe_last_sign_in {
                let now = Local::now();

                let now_duration = Duration::new(
                    (now.hour() * 3600 + now.minute() * 60 + now.second()) as u64,
                    0,
                );

                duration += now_duration - last_sign_in;
            }

            (maybe_last_sign_in.is_some(), duration)
        };

        let duration_pending_in_week = {
            expire_file(PRESENCE_FILE_NAME, FILE_DURATION_IN_SECS);

            let woffu_presence = read_json(PRESENCE_FILE_NAME).unwrap_or_else(|| {
            let client = Client::new();
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

            write_json(PRESENCE_FILE_NAME, &updated_json);
            updated_json
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

        Ok(())
    }
}
