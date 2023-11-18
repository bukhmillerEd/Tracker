//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Эдуард Бухмиллер on 08.11.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testViewController() {
        let vc = TrackersViewController()
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light))) 
    }

}
