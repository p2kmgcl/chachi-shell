use serde_json::{self, Value};
use std::{
    fs,
    time::{Duration, SystemTime},
};

const TMP_PATH: &str = "/tmp/seniore-temp/";

pub fn expire_file(name: &str, max_duration_in_secs: u64) {
    let file_path = TMP_PATH.to_owned() + name;
    let modified_time_result = fs::metadata(&file_path).and_then(|metadata| metadata.modified());

    if modified_time_result.is_err() {
        fs::remove_file(&file_path).unwrap_or(());
        return;
    }

    let file_duration = SystemTime::now()
        .duration_since(modified_time_result.unwrap())
        .unwrap_or(Duration::from_secs(max_duration_in_secs + 1));

    if file_duration.as_secs() > max_duration_in_secs {
        fs::remove_file(&file_path).expect(&file_path);
    }
}

pub fn read_file(name: &str) -> Option<String> {
    fs::read_to_string(TMP_PATH.to_owned() + name).ok()
}

pub fn write_file(name: &str, content: String) {
    fs::create_dir_all(TMP_PATH).expect(TMP_PATH);
    let file_name = TMP_PATH.to_owned() + name;
    fs::write(&file_name, content).expect(&file_name);
}

pub fn read_json(name: &str) -> Option<Value> {
    read_file(name).and_then(|file_content| serde_json::from_str(&file_content).ok())
}

pub fn write_json(name: &str, json: &Value) {
    write_file(name, json.to_string())
}
