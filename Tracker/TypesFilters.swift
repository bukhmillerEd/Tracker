import Foundation

enum TypesFilters {
    case allTraclers
    case allTrackersToday
    case completed
    case incomplete
    
    func getNameFilter() -> String {
        switch self {
        case .allTraclers:
            return NSLocalizedString("allTraclers", comment: "")
        case .allTrackersToday:
            return NSLocalizedString("allTrackersToday", comment: "")
        case .completed:
            return NSLocalizedString("completed", comment: "")
        case .incomplete:
            return NSLocalizedString("incomplete", comment: "")
        }
    }
}
