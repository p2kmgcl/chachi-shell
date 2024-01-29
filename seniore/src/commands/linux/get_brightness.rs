use crate::util::runnable::Runnable;
use crate::util::command::get_output;
use clap::Parser;

/// Gets the current brightness level.
#[derive(Parser)]
pub struct Command {}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        let output = get_output("/", "/bin/brightnessctl -m");
        let parts: Vec<String> = output.split(',').map(|chunk| chunk.to_string()).collect();
        let brightness = &parts[3];
        println!("💡 {}", brightness);
        Ok(())
    }
}
