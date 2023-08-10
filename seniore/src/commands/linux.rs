use crate::util::command;
use chrono::{Local, Locale};
use regex::Regex;

pub fn get_brightness() {
    let output = command::get_output("/", "/bin/brightnessctl -m");
    let parts: Vec<String> = output.split(',').map(|chunk| chunk.to_string()).collect();
    let brightness = &parts[3];
    println!("💡 {}", brightness);
}

pub fn get_date() {
    let date = Local::now();
    println!(
        "🗓️ {}",
        date.format_localized("%A, %e de %B, %H:%M", Locale::es_ES)
    );
}

pub fn get_volume() {
    let regex = Regex::new(r"\s(\d{1,3}%)\s").expect("number regex");
    let output = command::get_output("/", "/bin/pactl get-sink-volume @DEFAULT_SINK@");

    let volume = regex
        .captures(&output)
        .and_then(|captures| captures.get(1))
        .expect("🔉 Couldn't get volume");

    println!("🔉 {}", volume.as_str());
}
