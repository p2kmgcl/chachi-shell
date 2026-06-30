#!/usr/bin/swift
import EventKit
import Foundation

let store = EKEventStore()
let semaphore = DispatchSemaphore(value: 0)
var output = ""

func requestAccess(_ completion: @escaping (Bool) -> Void) {
    if #available(macOS 14.0, *) {
        store.requestFullAccessToEvents { granted, _ in completion(granted) }
    } else {
        store.requestAccess(to: .event) { granted, _ in completion(granted) }
    }
}

func fmt(_ secs: TimeInterval) -> String {
    let m = Int(secs / 60)
    return m >= 60 ? "\(m / 60)h \(m % 60)m" : "\(m)m"
}

requestAccess { granted in
    defer { semaphore.signal() }
    guard granted else { return }

    let cal = Calendar.current
    let now = Date()
    let startOfDay = cal.startOfDay(for: now)
    let endOfDay = cal.date(byAdding: .day, value: 1, to: startOfDay)!

    let predicate = store.predicateForEvents(withStart: startOfDay, end: endOfDay, calendars: nil)
    let events = store.events(matching: predicate).sorted { $0.startDate < $1.startDate }

    let allDay = events
        .filter { $0.isAllDay }
        .compactMap { $0.title }
        .joined(separator: "・")

    var timed = ""
    let timedEvents = events.filter { !$0.isAllDay }

    if let cur = timedEvents.first(where: { $0.startDate <= now && now < $0.endDate }) {
        timed = "\(cur.title ?? "")・until \(fmt(cur.endDate.timeIntervalSince(now)))"
    } else if let next = timedEvents.first(where: { $0.startDate > now }) {
        timed = "\(next.title ?? "")・in \(fmt(next.startDate.timeIntervalSince(now)))"
    }

    let parts = [allDay, timed].filter { !$0.isEmpty }
    output = parts.joined(separator: "・")
}

semaphore.wait()
print(output)
