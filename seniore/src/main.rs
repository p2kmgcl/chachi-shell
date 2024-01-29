mod commands;
mod util;

use clap::{Parser, Subcommand};
use commands::{liferay, linux, testing, woffu};
use util::runnable::Runnable;

/// Simple CLI to manage some daily tasks.
///
/// Required environment variables:
/// - CHACHI_PATH: gives access to some metadata and assets.
/// - LIFERAY_PORTAL_PATH: used by Liferay-related commands to interact with portal.
/// - WOFFU_TOKEN and WOFFU_USER_ID: required to login/logout in this magnificent service.
#[derive(Parser)]
#[command(author, version, verbatim_doc_comment)]
struct Cli {
    #[command(subcommand)]
    command: Subcommands,
}

#[derive(Subcommand)]
enum Subcommands {
    Liferay(liferay::Command),
    Linux(linux::Command),
    Testing(testing::Command),
    Woffu(woffu::Command),
}

fn main() -> Result<(), String> {
    match Cli::parse().command {
        Subcommands::Linux(command) => command.run(),
        Subcommands::Woffu(command) => {
            woffu::run_command(command);
            Ok(())
        }
        Subcommands::Testing(command) => command.run(),
        Subcommands::Liferay(command) => command.run(),
    }
}
