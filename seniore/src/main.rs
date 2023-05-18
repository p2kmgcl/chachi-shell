mod commands;
mod util;
use home;
use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();

    match (&args[1]).as_str() {
        "help" => print_help(),
        "liferay" => match (&args[2]).as_str() {
            "build-lang" => commands::liferay::build_lang(),
            "deploy-updated-modules" => commands::liferay::deploy_updated_modules(),
            "update-modules-cache" => commands::liferay::update_modules_cache(),
            _ => print_unknown(),
        },
        "linux" => match (&args[2]).as_str() {
            "get-brightness" => commands::linux::get_brightness(),
            "get-volume" => commands::linux::get_volume(),
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
    let help_path = home::home_dir()
        .expect("home dir")
        .join("Projects/chachi-shell/seniore/docs/help.txt");

    let help_string = fs::read_to_string(help_path).expect("help file");

    println!("\n{}", help_string);
}
