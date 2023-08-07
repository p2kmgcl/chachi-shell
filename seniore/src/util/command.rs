use ansi_escapes::{CursorUp, EraseEndLine, EraseLine};
use std::{path, process, thread, time};

pub fn get_output(input: &str) -> anyhow::Result<String> {
    let chunks: Vec<&str> = input.split(' ').collect();
    let command = chunks.first().unwrap();
    let args = chunks[1..].to_vec();
    let output = process::Command::new(command).args(args).output()?.stdout;
    Ok(String::from_utf8(output)?)
}

pub fn run(directory: &path::PathBuf, command: &path::PathBuf, args: &Vec<&str>) {
    let command_name = format!(
        "{}: {}",
        directory.clone().iter().last().unwrap().to_str().unwrap(),
        args.join(" ")
    );

    let mut running_command = process::Command::new(command)
        .current_dir(directory)
        .args(args)
        .stdout(process::Stdio::null())
        .spawn()
        .unwrap_or_else(|_| panic!("{}", command_name));

    let begin = time::Instant::now();
    println!("{}", command_name);

    loop {
        thread::sleep(time::Duration::from_millis(100));

        match running_command.try_wait() {
            Err(error) => {
                panic!("{:?}", error);
            }
            Ok(Some(status)) => {
                println!("{}{}[done] {}", CursorUp(1), EraseLine, status,);
                break;
            }
            Ok(None) => {
                println!(
                    "{}{}[{:.1}s] {}",
                    CursorUp(1),
                    EraseEndLine,
                    (time::Instant::now() - begin).as_secs_f64(),
                    command_name,
                );
            }
        }
    }
}
