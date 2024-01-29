use crate::util::runnable::Runnable;
use clap::Parser;
use chrono::{Local, Locale};

/// Gets the current date, using Spanish format.
#[derive(Parser)]
pub struct Command {}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        let date = Local::now();
        println!(
            "🗓️ {}",
            date.format_localized("%A, %e de %B, %H:%M", Locale::es_ES)
        );
        Ok(())
    }
}
