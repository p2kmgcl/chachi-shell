use crate::util::command;
use regex::Regex;

pub fn get_brightness() {
    let current_brightness = command::get_output("/bin/brightnessctl get").unwrap();
    let max_brightness = command::get_output("/bin/brightnessctl max").unwrap();

    println!("{} / {}", current_brightness, max_brightness);
}

pub fn get_volume() {
    let regex = Regex::new(r"\s(\d{2}%)\s").unwrap();
    let output = command::get_output("/bin/pactl get-sink-volume @DEFAULT_SINK@").unwrap();

    let volume = regex
        .captures(output.as_str())
        .and_then(|captures| captures.get(1))
        .map(|first_capture| first_capture.as_str())
        .unwrap_or("Couldn't get volume");

    println!("🔉 {}", volume);
}
