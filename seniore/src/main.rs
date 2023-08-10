mod commands;
mod util;
use commands::{liferay, linux, woffu};
use home::home_dir;
use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();

    match (args[1]).as_str() {
        "liferay" => match (args[2]).as_str() {
            "build-lang" => liferay::build_lang(),
            "format-modules" => liferay::format_modules(&args[3..].to_vec()),
            "deploy-modules" => liferay::deploy_modules(&args[3..].to_vec()),
            "get-updated-modules" => liferay::get_updated_modules(),
            "update-modules-cache" => liferay::update_modules_cache(),
            _ => print_help(),
        },
        "linux" => match (args[2]).as_str() {
            "get-brightness" => linux::get_brightness(),
            "get-date" => linux::get_date(),
            "get-volume" => linux::get_volume(),
            _ => print_help(),
        },
        "woffu" => match (args[2]).as_str() {
            "get-status" => woffu::get_status(),
            "toggle" => woffu::toggle(),
            _ => print_help(),
        },
        _ => print_help(),
    }
}

fn print_help() {
    println!("Unknown command");

    let help_path = home_dir()
        .expect("home dir")
        .join("Projects/chachi-shell/seniore/docs/help.txt");

    let help_string = fs::read_to_string(help_path).expect("help file");

    println!("\n{}", help_string);
}
