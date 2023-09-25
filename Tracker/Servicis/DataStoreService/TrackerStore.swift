import CoreData
import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func storeUpdated(didUpdate update: TrackersUpdate)
}

struct TrackersUpdate {
    let updatedIndexesPath: [IndexPath]
    let insertedIndexesPath: [IndexPath]
    let deletedIndexesPath: [IndexPath]
}

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    private weak var delegate: TrackerStoreDelegate?
    
    private var updatedIndexesPath: [IndexPath] = []
    private var insertedIndexesPath: [IndexPath] = []
    private var deletedIndexesPath: [IndexPath] = []
    
    init(delegate: TrackerStoreDelegate?) {
        super.init()
        self.delegate = delegate
    }
    
    func fetchTrackers(forWeekDay weekDay: String) {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        ]
        fetchRequest.predicate = NSPredicate(format: "schedule CONTAINS[cd] %@", weekDay)

        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "trackerCategories.title",
            cacheName: nil
        )
        fetchedResultsController = controller
        controller.delegate = self
        try? controller.performFetch()
    }
    
    func fetchTrackers(withStringInName string: String) {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        ]
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", string)
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController = controller
        controller.delegate = self
        try? controller.performFetch()
    }
    
    func fetchTrackers(withId id: UUID) -> TrackerCoreData? {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? context.fetch(fetchRequest).first
    }
    
    func addTracker(tracker: Tracker, in trackerCategoryCoreData: TrackerCategoryCoreData) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.id = tracker.id
        trackerCoreData.color = UIColor.hexString(from: tracker.color)
        trackerCoreData.schedule = converSchedule(from: tracker.schedule)
        trackerCoreData.trackerCategories = trackerCategoryCoreData
        try? context.save()
        return trackerCoreData
    }
    
    private func converSchedule(from schedule: [Schedule]) -> String {
        var scheduleInString = ""
        schedule.forEach { day in
            scheduleInString += scheduleInString.isEmpty ? "\(day.rawValue)" : ",\(day.rawValue)"
        }
        return scheduleInString
    }

}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updatedIndexesPath = []
        insertedIndexesPath = []
        deletedIndexesPath = []
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeUpdated(didUpdate: TrackersUpdate(
            updatedIndexesPath: updatedIndexesPath,
            insertedIndexesPath: insertedIndexesPath,
            deletedIndexesPath: deletedIndexesPath)
        )
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexesPath.append(indexPath)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexesPath.append(indexPath)
        case .move:
            break
        case .update:
            guard let indexPath = indexPath else { fatalError() }
            updatedIndexesPath.append(indexPath)
        @unknown default:
            break
        }
    }
}

