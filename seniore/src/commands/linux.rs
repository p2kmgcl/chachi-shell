use crate::util::command;
use regex::Regex;

pub fn get_brightness() {
    let output = command::get_output("/bin/brightnessctl -m").unwrap();
    let parts: Vec<&str> = output.split(",").collect();
    let brightness = parts[3];
    println!("💡 {}", brightness);
}

pub fn get_volume() {
    let regex = Regex::new(r"\s(\d{1,2}%)\s").unwrap();
    let output = command::get_output("/bin/pactl get-sink-volume @DEFAULT_SINK@").unwrap();

    let volume = regex
        .captures(output.as_str())
        .and_then(|captures| captures.get(1))
        .map(|first_capture| first_capture.as_str())
        .unwrap_or("Couldn't get volume");

    println!("🔉 {}", volume);
}
