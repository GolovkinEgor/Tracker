//
//  TrackerUITestsSnap.swift
//  TrackerUITestsSnap
//
//  Created by Golovkin Egor on 19.05.2025.
//

import XCTest
import SnapshotTesting
import UIKit
@testable import Tracker

final class TrackerSnapshotTests: XCTestCase {
  // setUp() можно вообще убрать, если больше нет shared setup

  func testMainScreen_lightMode() {
    // 1. создаём контроллер и прогружаем view
    let vc = TrackersViewController()
    vc.loadViewIfNeeded()

    // 2. задаём дату, чтобы результат был детерминирован
    vc.currentDate = Date(timeIntervalSince1970: 0) // например, «эпоха»

    // 3. делаем снимок (record: true только первый раз, чтобы создать эталон)
      assertSnapshot(
        matching: vc,
        as: .image(on: .iPhoneX),
        record: false,
        file: #file,
        testName: #function,
        line: #line
      )
  }

  func testMainScreen_darkMode() {
    let vc = TrackersViewController()
    vc.overrideUserInterfaceStyle = .dark
    vc.loadViewIfNeeded()
    vc.currentDate = Date(timeIntervalSince1970: 0)

      assertSnapshot(
        matching: vc,
        as: .image(on: .iPhoneX),
        record: false,
        file: #file,
        testName: #function,
        line: #line
      )

  }
}

