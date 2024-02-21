use crate::util::{notify, runnable::Runnable, tmp};
use clap::Parser;
use reqwest::blocking::Client;
use std::env;

/// Login or logout depending on current status.
#[derive(Parser)]
pub struct Command {}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        let notification_id = notify::send("Updating woffu sign status...", 0);
        let client = Client::new();
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

        tmp::expire_file(super::SIGNS_FILE_NAME, 0);
        tmp::expire_file(super::PRESENCE_FILE_NAME, 0);
        notify::update(notification_id, "Woffu sign status updated.", 1000);

        Ok(())
    }
}
