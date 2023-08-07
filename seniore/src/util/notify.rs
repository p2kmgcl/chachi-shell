use notify_rust::Notification;

static mut NEXT_NOTIFICATION_ID: u32 = 0;

pub fn send(body: &str, timeout: i32) -> u32 {
    let id;

    unsafe {
        id = NEXT_NOTIFICATION_ID;
        NEXT_NOTIFICATION_ID += 1;
    }

    update(id, body, timeout)
}

pub fn update(id: u32, body: &str, timeout: i32) -> u32 {
    let notification_handle = Notification::new()
        .id(id)
        .appname(format!("Seniore ({})", id).as_str())
        .summary("Seniore")
        .icon("seniore")
        .body(body)
        .timeout(timeout)
        .show()
        .expect("notification should be created");

    notification_handle.id()
}
