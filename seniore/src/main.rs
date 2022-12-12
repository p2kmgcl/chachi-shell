mod commands;
mod util;
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();

    // TODO:
    // - Update Slack status
    // - Move IDs to a secure place
    // - Add git checkout
    // - Add git send-pr
    // - Add liferay deploy
    // - Add liferay deploy-all
    // - Show help

    match (&args[1]).as_str() {
        "help" => print_help(),
        "liferay" => match (&args[2]).as_str() {
            "build-lang" => commands::liferay::build_lang(),
            _ => print_unknown(),
        },
        "woffu" => match (&args[2]).as_str() {
            "get-status" => commands::woffu::get_status(),
            "toggle" => commands::woffu::toggle(),
            _ => print_unknown(),
        },
        _ => print_unknown(),
    }
}

fn print_unknown() {
    println!("Unknown command");
    print_help();
}

fn print_help() {
    println!(
        "
Commands:
- help
- liferay build-lang
- woffu get-status
- woffu toggle

Environment variables:
- LIFERAY_PORTAL_PATH
- WOFFU_TOKEN
- WOFFU_USER_ID
    "
    );
}
