mod get_status;
mod toggle;

use crate::util::runnable::Runnable;
use serde_json::Value;
use std::time::Duration;

/// Interact with our very nice login manager.
#[derive(clap::Parser)]
#[command()]
pub struct Command {
    #[command(subcommand)]
    command: Subcommands,
}

#[derive(clap::Subcommand)]
enum Subcommands {
    GetStatus(get_status::Command),
    Toggle(toggle::Command),
}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        match &self.command {
            Subcommands::GetStatus(get_status) => get_status.run(),
            Subcommands::Toggle(toggle) => toggle.run(),
        }
    }
}

const FILE_DURATION_IN_SECS: u64 = 1800;
const SIGNS_FILE_NAME: &str = "woffu-signs";
const PRESENCE_FILE_NAME: &str = "woffu-presence";

fn format_duration(duration: Duration) -> String {
    let duration_secs = duration.as_secs();
    let hours = duration_secs / 3600;
    let minutes = (duration_secs / 60) % 60;

    format!("{:02}:{:02}", hours, minutes)
}

fn sign_entry_to_duration(entry: &Value) -> Duration {
    let parts: Vec<u64> = entry
        .as_object()
        .expect("entry should be an object")
        .get("ShortTrueTime")
        .expect("'ShortTrueTime' property should exist")
        .as_str()
        .expect("'ShortTrueTime' property should be a string")
        .to_string()
        .split(':')
        .map(|s| {
            s.parse::<u64>()
                .expect("'ShortTrueTime' should follow HH:MM:ss format")
        })
        .collect();

    Duration::new(parts[0] * 3600 + parts[1] * 60 + parts[2], 0)
}
