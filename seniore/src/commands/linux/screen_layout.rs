use crate::util::runnable::Runnable;
use clap::{Parser, ValueEnum};
use serde::{Deserialize, Serialize};
use std::process::Command as ProcessCommand;

/// Manage current layout setup for swaywm.
/// Currently only supports one external screen plus a laptop.
#[derive(Parser)]
pub struct Command {
    #[arg(value_enum)]
    laptop_position: Option<LaptopPosition>,
}

#[derive(ValueEnum, Clone)]
enum LaptopPosition {
    Disabled,
    Only,
    Left,
    Right,
    Down,
}

#[derive(Serialize, Deserialize)]
struct OutputList(Vec<Output>);

#[derive(Serialize, Deserialize)]
struct Output {
    name: String,
    rect: OutputPosition,
    modes: Vec<OutputMode>,
    current_mode: Option<OutputMode>,
}

#[derive(Serialize, Deserialize)]
struct OutputMode {
    width: u16,
    height: u16,
}

#[derive(Serialize, Deserialize)]
struct OutputPosition {
    x: u16,
    y: u16,
}

struct NamedOutputs<'a> {
    laptop: &'a Output,
    external: &'a Output,
}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        let output_list = get_outputs()?;

        if output_list.0.is_empty() {
            return Err("no screens found".to_owned());
        }

        if self.laptop_position.is_none() {
            println!("{}", output_list);
            return Ok(());
        }

        if output_list.0.len() > 2 {
            return Err("only 1 or 2 screens supported".to_owned());
        }

        if output_list.0.len() == 1 {
            return enable_output(&output_list.0[0]).map(|_| ());
        }

        let named_outputs = get_named_outputs(&output_list.0);

        match self.laptop_position.as_ref().unwrap() {
            LaptopPosition::Disabled => {
                disable_output(named_outputs.laptop)?;
                enable_output(named_outputs.external)?;
            }
            LaptopPosition::Only => {
                disable_output(named_outputs.external)?;
                enable_output(named_outputs.laptop)?;
            }
            LaptopPosition::Left => {
                let laptop_mode = enable_output(named_outputs.laptop)?;
                let external_mode = enable_output(named_outputs.external)?;

                set_output_position(
                    named_outputs.laptop,
                    OutputPosition {
                        x: 0,
                        y: external_mode.height - laptop_mode.height,
                    },
                )?;

                set_output_position(
                    named_outputs.external,
                    OutputPosition {
                        x: laptop_mode.width,
                        y: 0,
                    },
                )?;
            }
            LaptopPosition::Right => {
                let laptop_mode = enable_output(named_outputs.laptop)?;
                let external_mode = enable_output(named_outputs.external)?;

                set_output_position(
                    named_outputs.laptop,
                    OutputPosition {
                        x: external_mode.width,
                        y: external_mode.height - laptop_mode.height,
                    },
                )?;

                set_output_position(named_outputs.external, OutputPosition { x: 0, y: 0 })?;
            }
            LaptopPosition::Down => {
                let laptop_mode = enable_output(named_outputs.laptop)?;
                let external_mode = enable_output(named_outputs.external)?;

                set_output_position(
                    named_outputs.laptop,
                    OutputPosition {
                        x: (external_mode.width / 2) - (laptop_mode.width / 2),
                        y: external_mode.height,
                    },
                )?;

                set_output_position(named_outputs.external, OutputPosition { x: 0, y: 0 })?;
            }
        }

        Ok(())
    }
}

fn get_named_outputs(output: &[Output]) -> NamedOutputs {
    let first_output = &output[0];
    let second_output = &output[1];

    if first_output.name.starts_with("DP-") || first_output.name.starts_with("HDMI-") {
        NamedOutputs {
            laptop: second_output,
            external: first_output,
        }
    } else {
        NamedOutputs {
            laptop: first_output,
            external: second_output,
        }
    }
}

fn enable_output(output: &Output) -> Result<OutputMode, String> {
    run_swaymsg(["-p", format!("output {} enable", &output.name).as_str()]).map(|_| ())?;
    get_output_mode(&output.name).ok_or(format!("{} is not enabled", &output.name))
}

fn set_output_position(output: &Output, position: OutputPosition) -> Result<(), String> {
    run_swaymsg([
        "-p",
        format!(
            "output {} position {} {}",
            &output.name, &position.x, &position.y
        )
        .as_str(),
    ])
    .map(|_| ())
}

fn get_outputs() -> Result<OutputList, String> {
    // println!("{}", run_swaymsg(["-rt", "get_outputs"])?);

    serde_json::from_str(run_swaymsg(["-rt", "get_outputs"])?.as_str())
        .map_err(|error| error.to_string().as_str().to_owned())
}

fn get_output_mode(output_name: &str) -> Option<OutputMode> {
    get_outputs().ok().and_then(|output_list_value| {
        for output in output_list_value.0 {
            if output.name == output_name {
                return output.current_mode;
            }
        }

        None
    })
}

fn disable_output(output: &Output) -> Result<(), String> {
    run_swaymsg(["-p", format!("output {} disable", &output.name).as_str()]).map(|_| ())
}

fn run_swaymsg<I, S>(args: I) -> Result<String, String>
where
    I: IntoIterator<Item = S>,
    I: std::fmt::Debug,
    S: AsRef<std::ffi::OsStr>,
{
    // println!("{:?}", args);

    ProcessCommand::new("/usr/bin/swaymsg")
        .args(args)
        .output()
        .map_err(|error| error.to_string())
        .map(|output| {
            if output.status.success() {
                Ok(String::from_utf8(output.stdout).unwrap())
            } else {
                Err(String::from_utf8(output.stdout).unwrap())
            }
        })?
}

impl std::fmt::Display for OutputList {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        for output in &self.0 {
            write!(f, "{}: ", output.name)?;

            match &output.current_mode {
                Some(mode) => writeln!(
                    f,
                    "{}x{} ({},{})",
                    mode.width, mode.height, output.rect.x, output.rect.y
                )?,
                None => writeln!(f, "disabled")?,
            }
        }

        Ok(())
    }
}
