
import UIKit

protocol DataProvider {
    init (delegate: TrackersViewControllerDelegate?)
    func filterTrackers(byName name: String)
    func numberOfSections() -> Int
    func numberOfRowsInSection(_ section: Int) -> Int
    func getTracker(at indexPath : IndexPath) -> Tracker?
    func getNamesSections() -> [String]
    func addNewTracker(tracker: Tracker, inCategoryWithTitle titleCategory: String)
    func getIDCompletedTrackers(in date: Date) -> Set<UUID>
    func getCountCompletedTrackers(withID id: UUID) -> UInt
    func addRecordTracker(_ record: TrackerRecord)
    func removeRecordTracker(_ record: TrackerRecord)
    func getAllNamesCategories() -> [String]
    func addNewTrackerCategory(withTitle title: String) -> TrackerCategoryCoreData?
    func deleteCotegory(withName name: String)
    func editTitleCategory(withName name: String, newName: String)
    func removeTracker(withID id: UUID)
    func saveEditedTracker(tracker: Tracker, titleTrackerCategory: String)
    func removeTrackerFromCategory(withID id: UUID, from nameCategory: String)
    func getTrackers(withFilter selectedFilter: TypesFilters, forWeakDay weakDay: String)
    func getCountTrackers() -> Int
    func getCompletedTrackers() -> UInt
}

final class DataProviderForCoreData: DataProvider {
    
    lazy private var trackerStore: TrackerStore = TrackerStore(delegate: self)
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerReckordStore = TrackerRecordStore()
    private weak var delegate: TrackersViewControllerDelegate?
    
    init(delegate: TrackersViewControllerDelegate?) {
        self.delegate = delegate
    }
    
    func filterTrackers(byName name: String) {
        trackerStore.fetchTrackers(withStringInName: name)
    }
    
    func numberOfSections() -> Int {
        trackerStore.fetchedResultsController?.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        trackerStore.fetchedResultsController?.sections?[section].objects?.count ?? 0
    }
    
    func getTracker(at indexPath : IndexPath) -> Tracker? {
        guard let trackerCoreData = trackerStore.fetchedResultsController?
            .sections?[indexPath.section]
            .objects?[indexPath.row] as? TrackerCoreData
        else { return nil }
        
        return Tracker(id: trackerCoreData.id ?? UUID(),
                       name: trackerCoreData.name ?? "",
                       color: UIColor.color(from: trackerCoreData.color),
                       emoji: trackerCoreData.emoji ?? "",
                       schedule: Schedule.decodeSchedule(from: trackerCoreData.schedule ?? ""))
    }
    
    func getNamesSections() -> [String] {
        return trackerStore.fetchedResultsController?.sections?.map{$0.name} ?? []
    }
    
    func getIDCompletedTrackers(in date: Date) -> Set<UUID> {
        return trackerReckordStore.getIDCompletedTrackers(forDate: date)
    }
    
    func getCountCompletedTrackers(withID id: UUID) -> UInt {
        guard let trackerCoreData = trackerStore.fetchTrackers(withId: id) else { return 0}
        return trackerReckordStore.getCountTrackerRecords(for: trackerCoreData)
    }
    
    func addNewTracker(tracker: Tracker, inCategoryWithTitle titleCategory: String) {
        var trackerCategory = try? trackerCategoryStore.getTrackerCategoryCoreData(byName: titleCategory)
        if trackerCategory == nil {
            trackerCategory = try? trackerCategoryStore.addNewTrackerCategory(titleCategory)
        }
        guard let trackerCategory else { return }
        let _ = trackerStore.addTracker(tracker: tracker, in: trackerCategory)
    }
    
    func addRecordTracker(_ record: TrackerRecord) {
        guard let trackerCoreData = trackerStore.fetchTrackers(withId: record.id) else { return }
        let _ = trackerReckordStore.addTrackerRecord(trackerCoreData: trackerCoreData, date: record.date)
    }
    
    func removeRecordTracker(_ record: TrackerRecord) {
        guard let trackerCoreData = trackerStore.fetchTrackers(withId: record.id) else { return }
        let _ = trackerReckordStore.deleteTrackerRecord(trackerCoreData: trackerCoreData, date: record.date)
    }
    
    func getAllNamesCategories() -> [String] {
        do {
            return try trackerCategoryStore.getAllCategories().compactMap{ $0.title}
        } catch {
            return []
        }
    }
    
    func addNewTrackerCategory(withTitle title: String) -> TrackerCategoryCoreData? {
        let trackerCategory = try? trackerCategoryStore.getTrackerCategoryCoreData(byName: title)
        return trackerCategory == nil ? try? trackerCategoryStore.addNewTrackerCategory(title) : trackerCategory
    }
    
    func deleteCotegory(withName name: String) {
        let categoruCoreData = try? trackerCategoryStore.getTrackerCategoryCoreData(byName: name)
        guard let categoruCoreData else { return }
        try? trackerCategoryStore.deleteCotegory(category: categoruCoreData)
    }
    
    func editTitleCategory(withName name: String, newName: String) {
        try? trackerCategoryStore.editTitleCategory(withName: name, newName: newName)
    }
    
    func removeTracker(withID id: UUID) {
        trackerStore.removeTracker(withID: id)
    }
    
    func saveEditedTracker(tracker: Tracker, titleTrackerCategory: String) {
        guard let trackerCategory = try? trackerCategoryStore.getTrackerCategoryCoreData(byName: titleTrackerCategory) else { return }
        trackerStore.saveEditedTracker(tracker: tracker, in: trackerCategory)
    }
    
    func removeTrackerFromCategory(withID id: UUID, from nameCategory: String) {
        guard let trackerCoreData = trackerStore.removeTrackerFromCategory(withID: id, from: nameCategory) else { return }
        trackerCategoryStore.removeRelationship(with: trackerCoreData, nameCategory: nameCategory)
    }
    
    func getTrackers(withFilter selectedFilter: TypesFilters, forWeakDay weakDay: String) {
        var сompleted: Bool?
        switch selectedFilter {
        case .allTraclers:
            break
        case .allTrackersToday:
            break
        case .completed:
            сompleted = true
        case .incomplete:
            сompleted = false
        }
        trackerStore.fetchTrackers(forWeekDay: weakDay, сompleted: сompleted)
    }
    
    func getCountTrackers() -> Int {
        trackerStore.fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func getCompletedTrackers() -> UInt {
        return trackerReckordStore.getCountTrackerRecords(for: nil)
    }
    
}

extension DataProviderForCoreData: TrackerStoreDelegate {
    func storeUpdated(didUpdate update: TrackersUpdate) {
        delegate?.updateTrackersCollections(didUpdate: update)
    }
}
