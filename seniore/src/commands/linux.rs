mod get_brightness;
mod get_date;
mod get_volume;
mod screen_layout;

use crate::util::runnable::Runnable;
use clap::{Parser, Subcommand};

/// Some commands that interact with arbitrary linux systems.
#[derive(Parser)]
#[command()]
pub struct Command {
    #[command(subcommand)]
    command: Subcommands,
}

#[derive(Subcommand)]
#[allow(clippy::enum_variant_names)]
enum Subcommands {
    GetBrightness(get_brightness::Command),
    GetDate(get_date::Command),
    GetVolume(get_volume::Command),
    ScreenLayout(screen_layout::Command),
}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        match &self.command {
            Subcommands::GetBrightness(get_brightness) => get_brightness.run(),
            Subcommands::GetDate(get_date) => get_date.run(),
            Subcommands::GetVolume(get_volume) => get_volume.run(),
            Subcommands::ScreenLayout(screen_layout) => screen_layout.run(),
        }
    }
}
