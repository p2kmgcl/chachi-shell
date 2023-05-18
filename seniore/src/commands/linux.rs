use crate::util::command;
use regex::Regex;

pub fn get_brightness() {
    fn parse(input: &str) -> f32 {
        let text = command::get_output(format!("/bin/brightnessctl {}", input).as_str()).unwrap();
        return text.trim().parse().unwrap();
    }

    let current_brightness = parse("get");
    let max_brightness = parse("max");

    println!("💡 {:.0}%", ((current_brightness / max_brightness) * 100.0));
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
