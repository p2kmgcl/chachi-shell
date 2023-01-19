use std::{
    env,
    path::{Path, PathBuf},
};

use crate::util::command;

pub fn build_lang() {
    command::run(
        &get_portal_item_path("/modules/apps/portal-language/portal-language-lang/"),
        &get_portal_item_path("/gradlew"),
        &vec!["formatSource"],
    );

    command::run(
        &get_portal_item_path("/modules/apps/portal-language/portal-language-lang/"),
        &get_portal_item_path("/gradlew"),
        &vec!["buildLang"],
    );
    command::run(
        &get_portal_item_path("/modules/apps/portal-language/portal-language-lang/"),
        &get_portal_item_path("/gradlew"),
        &vec!["clean", "deploy", "-Dbuild=portal"],
    );
}

fn get_portal_item_path(item_path: &str) -> PathBuf {
    let portal_path = env::var("LIFERAY_PORTAL_PATH").expect("LIFERAY_PORTAL_PATH env variable");
    let resolved_path = portal_path.clone() + item_path;

    return Path::new(resolved_path.as_str())
        .canonicalize()
        .expect(item_path);
}
