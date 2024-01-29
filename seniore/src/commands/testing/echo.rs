use crate::util::runnable::Runnable;
use clap::Parser;

/// Returns the given arguments as a single string.
#[derive(Parser)]
pub struct Command {
    stuff: Vec<String>,
}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        println!("{}", self.stuff.join(" "));
        Ok(())
    }
}
