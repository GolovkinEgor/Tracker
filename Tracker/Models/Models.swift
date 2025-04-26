//
//  Models.swift
//  Tracker
//
//  Created by Golovkin Egor on 05.04.2025.
//


import UIKit
enum ScheduleItems: String, CaseIterable {
    case Monday = "Понедельник"
    case Tuesday = "Вторник"
    case Wednesday = "Среда"
    case Thursday = "Четверг"
    case Friday = "Пятница"
    case Saturday = "Суббота"
    case Sunday = "Воскресенье"
}

struct Tracker: Identifiable {
    let id: UUID = UUID()
    let name: String
    let emoji: String
    let schedule: [ScheduleItems]?
    let color: UIColor
    let createdDate: Date

}
struct TrackerCategory {
    let name: String
    let trackers: [Tracker]
}

struct TrackerRecord: Hashable {
    let id: UUID
    let date: Date
}
let daysOfWeek: [String] = [
    "Понедельник",
    "Вторник",
    "Среда",
    "Четверг",
    "Пятница",
    "Суббота",
    "Воскресенье"
]


let shortDayNames: [String: String] = [
    "Понедельник": "Пн",
    "Вторник": "Вт",
    "Среда": "Ср",
    "Четверг": "Чт",
    "Пятница": "Пт",
    "Суббота": "Сб",
    "Воскресенье": "Вс"
]
