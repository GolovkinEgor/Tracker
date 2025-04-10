//
//  CreateTrackerProtocol.swift
//  Tracker
//
//  Created by Golovkin Egor on 10.04.2025.
//

import Foundation

protocol CreateTrackerProtocol: AnyObject {
    func cancelCreateTracker()
    func addTracker(for category: TrackerCategory)
}
