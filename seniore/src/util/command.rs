use std::{
    path::PathBuf,
    process::{Command, Stdio},
    thread,
    time::{Duration, Instant},
};

pub fn get_output(input: &str) -> anyhow::Result<String> {
    let chunks: Vec<&str> = input.split(" ").collect();
    let command = chunks.first().unwrap();
    let args = chunks[1..].to_vec();
    let output = Command::new(command).args(args).output()?.stdout;
    return Ok(String::from_utf8(output)?);
}

pub fn run(directory: &PathBuf, command: &PathBuf, args: &Vec<&str>) {
    let command_name = format!(
        "{}: {}",
        directory.clone().iter().last().unwrap().to_str().unwrap(),
        args.join(" ")
    );

    let mut running_command = Command::new(command)
        .current_dir(directory)
        .args(args)
        .stdout(Stdio::null())
        .spawn()
        .expect(&command_name.as_str());

    let begin = Instant::now();
    println!("{}", command_name);

    loop {
        thread::sleep(Duration::from_millis(100));

        match running_command.try_wait() {
            Err(error) => {
                panic!("{:?}", error);
            }
            Ok(Some(status)) => {
                println!(
                    "{}{}[done] {}",
                    ansi_escapes::CursorUp(1),
                    ansi_escapes::EraseLine,
                    status,
                );
                break;
            }
            Ok(None) => {
                println!(
                    "{}{}[{:.1}s] {}",
                    ansi_escapes::CursorUp(1),
                    ansi_escapes::EraseEndLine,
                    (Instant::now() - begin).as_secs_f64(),
                    command_name,
                );
            }
        }
    }
}
