mod echo;

use crate::util::runnable::Runnable;
use clap::{Parser, Subcommand};

/// Testing random scripts.
#[derive(Parser)]
pub struct Command {
    #[command(subcommand)]
    subcommand: Subcommands,
}

#[derive(Subcommand)]
enum Subcommands {
    Echo(echo::Command),
}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        match &self.subcommand {
            Subcommands::Echo(echo) => echo.run(),
        }
    }
}
