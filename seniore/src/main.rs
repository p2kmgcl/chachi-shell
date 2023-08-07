mod commands;
mod util;
use commands::{liferay, linux, woffu};
use home::home_dir;
use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();

    let some_f: Option<fn()> = match (args[1]).as_str() {
        "liferay" => match (args[2]).as_str() {
            "build-lang" => Some(liferay::build_lang),
            "deploy-updated-modules" => Some(liferay::deploy_updated_modules),
            "update-modules-cache" => Some(liferay::update_modules_cache),
            _ => None,
        },
        "linux" => match (args[2]).as_str() {
            "get-brightness" => Some(linux::get_brightness),
            "get-date" => Some(linux::get_date),
            "get-volume" => Some(linux::get_volume),
            _ => None,
        },
        "woffu" => match (args[2]).as_str() {
            "get-status" => Some(woffu::get_status),
            "toggle" => Some(woffu::toggle),
            _ => None,
        },
        _ => None,
    };

    if let Some(f) = some_f {
        f();
    } else {
        println!("Unknown command");

        let help_path = home_dir()
            .expect("home dir")
            .join("Projects/chachi-shell/seniore/docs/help.txt");

        let help_string = fs::read_to_string(help_path).expect("help file");

        println!("\n{}", help_string);
    }
}
