import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    
    func getTrackerCategoryCoreData(byName name: String) throws -> TrackerCategoryCoreData? {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", name)
        return try context.fetch(fetchRequest).first
    }
    
    func addNewTrackerCategory(_ title: String) throws -> TrackerCategoryCoreData {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = title
        try context.save()
        return trackerCategoryCoreData
    }
    
    func getAllCategories() throws -> [TrackerCategoryCoreData] {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        return try context.fetch(fetchRequest)
    }
    
    func deleteCotegory(category: TrackerCategoryCoreData) throws {
        context.delete(category)
        try? context.save()
    }
    
    func editTitleCategory(withName name: String, newName: String) throws {
        let categoryCoreData = try getTrackerCategoryCoreData(byName: name)
        guard let categoryCoreData else { return }
        categoryCoreData.title = newName
        try context.save()
    }
}
