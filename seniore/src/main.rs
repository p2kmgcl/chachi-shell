mod commands;
mod util;
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() != 3 {
        println!("Invalid arguments");
        return;
    }

    let command = &args[1];
    let subcommand: &String = &args[2];

    match command.as_str() {
        "woffu" => match subcommand.as_str() {
            "get-status" => commands::woffu::get_status(),
            "toggle" => commands::woffu::toggle(),
            _ => println!("Unknown command"),
        },
        _ => println!("Unknown command"),
    }
}
