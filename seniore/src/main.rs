mod commands;
mod util;
use clap::Parser;
use clap::Subcommand;
use commands::{liferay, linux, woffu};

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
    Woffu(woffu::Command),
}

fn main() {
    match Cli::parse().command {
        Subcommands::Linux(command) => linux::run_command(command),
        Subcommands::Woffu(command) => woffu::run_command(command),
        Subcommands::Liferay(command) => liferay::run_command(command),
    }
}
