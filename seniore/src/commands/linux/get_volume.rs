use crate::util::command::get_output;
use crate::util::runnable::Runnable;
use clap::Parser;
use regex::Regex;

/// Gets the current volume level of the default output device.
#[derive(Parser)]
pub struct Command {}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        let regex = Regex::new(r"\s(\d{1,3}%)\s").expect("number regex");
        let output = get_output("/", "/bin/pactl get-sink-volume @DEFAULT_SINK@");

        let volume = regex
            .captures(&output)
            .and_then(|captures| captures.get(1))
            .expect("🔉 Couldn't get volume");

        println!("🔉 {}", volume.as_str());

        Ok(())
    }
}
