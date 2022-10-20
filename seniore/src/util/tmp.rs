use serde_json;
use std::error::Error;
use std::fs;
use std::result::Result;
use std::time::{Duration, SystemTime};

const TMP_PATH: &str = "/tmp/seniore-temp/";

pub fn expire_file(name: &str, max_duration_in_secs: u64) {
    let file_path = TMP_PATH.to_owned() + name;
    let modified_time_result =
        fs::metadata(file_path.as_str()).and_then(|metadata| metadata.modified());

    if modified_time_result.is_err() {
        return fs::remove_file(file_path.as_str()).unwrap_or(());
    }

    let file_duration = SystemTime::now()
        .duration_since(modified_time_result.unwrap())
        .unwrap_or(Duration::from_secs(max_duration_in_secs + 1));

    if file_duration.as_secs() > max_duration_in_secs {
        return fs::remove_file(file_path.as_str()).unwrap_or(());
    }
}

pub fn read_json(name: &str) -> Result<serde_json::Value, Box<dyn Error>> {
    let content = fs::read_to_string(TMP_PATH.to_owned() + name)?;
    let value: serde_json::Value = serde_json::from_str(content.as_str())?;
    return Ok(value);
}

pub fn write_json(name: &str, json: &serde_json::Value) -> Result<(), std::io::Error> {
    match fs::create_dir_all(TMP_PATH) {
        Ok(_) => fs::write(TMP_PATH.to_owned() + name, json.to_string()),
        result => result,
    }
}
