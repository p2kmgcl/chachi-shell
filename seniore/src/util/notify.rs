use notify_rust::Notification;

pub fn send() -> Notification {
    Notification::new()
        .summary("Seniore")
        .icon("seniore")
        .to_owned()
}
