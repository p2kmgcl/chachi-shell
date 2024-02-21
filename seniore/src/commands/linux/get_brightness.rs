use crate::util::{command, runnable::Runnable};
use clap::Parser;

/// Gets the current brightness level.
#[derive(Parser)]
pub struct Command {}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        let output = command::get_output("/", "/bin/brightnessctl -m");
        let parts: Vec<String> = output.split(',').map(|chunk| chunk.to_string()).collect();
        let brightness = &parts[3];
        println!("💡 {}", brightness);
        Ok(())
    }
}
