use crate::util::command;
use chrono::{Local, Locale};
use regex::Regex;

/// Some commands that interact with arbitrary linux systems.
#[derive(clap::Parser)]
#[command()]
pub struct Command {
    #[command(subcommand)]
    command: Subcommands,
}

#[derive(clap::Subcommand)]
enum Subcommands {
    /// Gets the current brightness level.
    GetBrightness,
    /// Gets the current date, using Spanish format.
    GetDate,
    /// Gets the current volume level of the default output device.
    GetVolume,
}

pub fn run_command(command: Command) {
    match command.command {
        Subcommands::GetBrightness => get_brightness(),
        Subcommands::GetDate => get_date(),
        Subcommands::GetVolume => get_volume(),
    }
}

fn get_brightness() {
    let output = command::get_output("/", "/bin/brightnessctl -m");
    let parts: Vec<String> = output.split(',').map(|chunk| chunk.to_string()).collect();
    let brightness = &parts[3];
    println!("💡 {}", brightness);
}

fn get_date() {
    let date = Local::now();
    println!(
        "🗓️ {}",
        date.format_localized("%A, %e de %B, %H:%M", Locale::es_ES)
    );
}

fn get_volume() {
    let regex = Regex::new(r"\s(\d{1,3}%)\s").expect("number regex");
    let output = command::get_output("/", "/bin/pactl get-sink-volume @DEFAULT_SINK@");

    let volume = regex
        .captures(&output)
        .and_then(|captures| captures.get(1))
        .expect("🔉 Couldn't get volume");

    println!("🔉 {}", volume.as_str());
}
