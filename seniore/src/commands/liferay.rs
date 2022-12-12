use std::{
    env,
    path::{Path, PathBuf},
    process::{Command, Stdio},
    thread,
    time::Duration,
};

use indicatif::{ProgressBar, ProgressStyle};

const SPINNER_TICKS: [&str; 10] = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];

pub fn build_lang() {
    run_gradle_command(
        "/modules/apps/portal-language/portal-language-lang/",
        &vec!["buildLang"],
    );
}

fn get_portal_item_path(item_path: &str) -> PathBuf {
    let portal_path = env::var("LIFERAY_PORTAL_PATH").expect("LIFERAY_PORTAL_PATH env variable");
    let resolved_path = portal_path.clone() + item_path;

    return Path::new(resolved_path.as_str())
        .canonicalize()
        .expect(item_path);
}

fn run_gradle_command(module_path_str: &str, args: &Vec<&str>) {
    let module_path = get_portal_item_path(module_path_str);
    let gradlew_path = get_portal_item_path("/gradlew");

    let command_name = format!(
        "[{}] {}",
        module_path.clone().iter().last().unwrap().to_str().unwrap(),
        args.join(" ")
    );

    let progress_bar = ProgressBar::new_spinner();
    progress_bar.set_message(command_name.clone());

    progress_bar.set_style(
        ProgressStyle::with_template("{spinner} {msg}")
            .unwrap()
            .tick_strings(&SPINNER_TICKS),
    );

    let mut command = Command::new(gradlew_path)
        .current_dir(module_path)
        .args(args)
        .stdout(Stdio::null())
        .spawn()
        .expect(command_name.as_str());

    loop {
        match command.try_wait() {
            Err(error) => {
                panic!("{:?}", error);
            }
            Ok(None) => {
                progress_bar.tick();
                thread::sleep(Duration::from_millis(100));
            }
            Ok(Some(status)) => {
                let elapsed = progress_bar.elapsed();
                progress_bar.finish_and_clear();

                println!(
                    "({}) {}s {}",
                    status.code().unwrap(),
                    elapsed.as_secs_f64().round(),
                    command_name.as_str(),
                );

                break;
            }
        }
    }
}
