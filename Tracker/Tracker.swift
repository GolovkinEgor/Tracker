//
//  Tracker.swift
//  Tracker
//
//  Created by Golovkin Egor on 27.03.2025.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday] // Например, [.monday, .friday]
    let isCompleted: Bool
}

enum Weekday: String, CaseIterable {
    case monday = "Пн"
    case tuesday = "Вт"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
    case sunday = "Вс"
}
