//
//  TrackerCellDelegate.swift
//  Tracker
//
//  Created by Golovkin Egor on 10.04.2025.
//

import Foundation

protocol TrackerCellDelegate: AnyObject {
    func trackerCompleated(id: UUID)
    func countRecordsByID(id: UUID) -> Int
    func checkDate() -> Bool
}
