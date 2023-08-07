use serde_json;
use serde_json::{from_str, Value};
use std::{error, fs, io, time};

const TMP_PATH: &str = "/tmp/seniore-temp/";

pub fn expire_file(name: &str, max_duration_in_secs: u64) {
    let file_path = TMP_PATH.to_owned() + name;
    let modified_time_result =
        fs::metadata(file_path.as_str()).and_then(|metadata| metadata.modified());

    if modified_time_result.is_err() {
        return fs::remove_file(file_path.as_str()).unwrap_or(());
    }

    let file_duration = time::SystemTime::now()
        .duration_since(modified_time_result.unwrap())
        .unwrap_or(time::Duration::from_secs(max_duration_in_secs + 1));

    if file_duration.as_secs() > max_duration_in_secs {
        return fs::remove_file(file_path.as_str()).unwrap_or(());
    }
}

pub fn read_file(name: &str) -> Result<String, io::Error> {
    fs::read_to_string(TMP_PATH.to_owned() + name)
}

pub fn write_file(name: &str, content: String) -> Result<(), io::Error> {
    match fs::create_dir_all(TMP_PATH) {
        Ok(_) => fs::write(TMP_PATH.to_owned() + name, content),
        result => result,
    }
}

pub fn read_json(name: &str) -> Result<Value, Box<dyn error::Error>> {
    let value: Value = from_str(read_file(name)?.as_str())?;
    Ok(value)
}

pub fn write_json(name: &str, json: &Value) -> Result<(), io::Error> {
    write_file(name, json.to_string())
}
