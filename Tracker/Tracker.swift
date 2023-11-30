//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by Эдуард Бухмиллер on 14.07.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor?
    let emoji: String
    let schedule: [Schedule]
}

enum Schedule: Int, CaseIterable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
    func representation() -> String {
        switch self {
        case .monday:
            return NSLocalizedString("monday", comment: "")
        case .tuesday:
            return NSLocalizedString("tuesday", comment: "")
        case .wednesday:
            return NSLocalizedString("wednesday", comment: "")
        case .thursday:
            return NSLocalizedString("thursday", comment: "")
        case .friday:
            return NSLocalizedString("friday", comment: "")
        case .saturday:
            return NSLocalizedString("saturday", comment: "")
        case .sunday:
            return NSLocalizedString("sunday", comment: "")
        }
    }
    
    func shortRepresentation() -> String {
        switch self {
        case .monday:
            return NSLocalizedString("mon", comment: "")
        case .tuesday:
            return NSLocalizedString("tue", comment: "")
        case .wednesday:
            return NSLocalizedString("wed", comment: "")
        case .thursday:
            return NSLocalizedString("thu", comment: "")
        case .friday:
            return NSLocalizedString("fri", comment: "")
        case .saturday:
            return NSLocalizedString("sat", comment: "")
        case .sunday:
            return NSLocalizedString("sun", comment: "")
        }
    }
    
    static func decodeSchedule(from string: String) -> [Schedule] {
        let components = string.components(separatedBy: ",")
        var schedules: [Schedule] = []
        for component in components {
            if let value = Int(component), let schedule = Schedule(rawValue: value) {
                schedules.append(schedule)
            }
        }
        return schedules
    }
    
}
