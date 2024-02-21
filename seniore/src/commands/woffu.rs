mod get_status;
mod toggle;

use crate::util::runnable::Runnable;

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

const SIGNS_FILE_NAME: &str = "woffu-signs";
const PRESENCE_FILE_NAME: &str = "woffu-presence";
