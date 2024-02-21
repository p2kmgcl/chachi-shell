use ansi_escapes::{CursorUp, EraseEndLine};
use std::process::{Command, ExitStatus, Stdio};
use std::{path, thread, time};

pub fn get_output(directory: &str, full_command: &str) -> String {
    let chunks: Vec<String> = full_command
        .split(' ')
        .map(|chunk| chunk.to_string())
        .collect();

    let command = chunks.first().expect(full_command);
    let args = chunks[1..].to_vec();

    let output = Command::new(command)
        .current_dir(directory)
        .args(args)
        .output()
        .expect(full_command)
        .stdout;

    String::from_utf8(output).expect(full_command)
}

pub fn run(directory: &str, full_command: &str) {
    let chunks: Vec<String> = full_command
        .split(' ')
        .map(|chunk| chunk.to_string())
        .collect();

    let command = chunks.first().expect(full_command);
    let args = chunks[1..].to_vec();

    let command_name = format!(
        "{}: {}",
        path::Path::new(&directory)
            .iter()
            .last()
            .expect(directory)
            .to_str()
            .expect(directory),
        args.join(" ")
    );

    let mut running_command = Command::new(command)
        .current_dir(directory)
        .args(args)
        .stdout(Stdio::null())
        .spawn()
        .unwrap_or_else(|_| panic!("{command_name}"));

    let begin = time::Instant::now();
    println!("{command_name}");

    loop {
        thread::sleep(time::Duration::from_millis(100));

        let print_elapsed_time = |maybe_status: Option<ExitStatus>| {
            let elapsed_time = (time::Instant::now() - begin).as_secs_f64();

            let (suffix, lines_up) = match maybe_status {
                Some(status) => match status.code() {
                    Some(0) => ("✔️", 2),
                    _ => ("❌", 2),
                },
                _ => ("⏳", 1),
            };

            println!(
                "{}{}[{:.1}s] {} {}",
                CursorUp(lines_up),
                EraseEndLine,
                elapsed_time,
                command_name,
                suffix,
            );
        };

        match running_command.try_wait() {
            Err(error) => {
                panic!("{:?}", error);
            }
            Ok(maybe_status) => {
                print_elapsed_time(maybe_status);

                if maybe_status.is_some() {
                    break;
                }
            }
        }
    }
}
