
import UIKit
import CoreData

final class TrackerRecordStore {
    private let context: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    
    func addTrackerRecord(trackerCoreData: TrackerCoreData, date: Date) -> TrackerRecordCoreData {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.date = date
        trackerRecordCoreData.trackers = trackerCoreData
        try? context.save()
        return trackerRecordCoreData
    }
    
    func deleteTrackerRecord(trackerCoreData: TrackerCoreData, date: Date) {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let predicate1 = NSPredicate(format: "trackers == %@", trackerCoreData)
        let predicate2 = NSPredicate(format: "date == %@", date as CVarArg)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        guard let trackerRecordCoreData = try? context.fetch(fetchRequest).first
        else { return }
        context.delete(trackerRecordCoreData)
        try? context.save()
    }
    
    func getCountTrackerRecords(for trackerCoreData: TrackerCoreData) -> UInt {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let predicate1 = NSPredicate(format: "trackers == %@", trackerCoreData)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1])
        let objects = try? context.fetch(fetchRequest)
        return UInt(objects?.count ?? 0)
    }
    
    func getIDCompletedTrackers(forDate date: Date) -> Set<UUID> {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let predicate = NSPredicate(format: "date == %@", date as CVarArg)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
        guard let trackerRecordCoreData = try? context.fetch(fetchRequest)
        else { return Set<UUID>()}
        return Set<UUID>(trackerRecordCoreData.compactMap{$0.trackers?.id})
    }
    
}
