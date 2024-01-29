mod get_brightness;
mod get_date;
mod get_volume;

use clap::{Parser, Subcommand};
use crate::util::runnable::Runnable;

/// Some commands that interact with arbitrary linux systems.
#[derive(Parser)]
#[command()]
pub struct Command {
    #[command(subcommand)]
    command: Subcommands,
}

#[derive(Subcommand)]
enum Subcommands {
    GetBrightness(get_brightness::Command),
    GetDate(get_date::Command),
    GetVolume(get_volume::Command),
}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        match &self.command {
            Subcommands::GetBrightness(get_brightness) => get_brightness.run(),
            Subcommands::GetDate(get_date) => get_date.run(),
            Subcommands::GetVolume(get_volume) => get_volume.run(),
        }
    }
}
