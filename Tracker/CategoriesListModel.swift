import Foundation

class CategoriesListModel {
  
    private var dataProvider: DataProviderForCoreData?
    
    var lastSelectedCategory: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "lastSelectedCategory")
        }
        get {
            return UserDefaults.standard.value(forKey: "lastSelectedCategory") as? String
        }
    }
    
    init() {
        self.dataProvider = DataProviderForCoreData(delegate: nil)
    }
    
    func getAllNamesCategories() -> [String] {
        return dataProvider?.getAllNamesCategories() ?? []
    }
    
    func deleteCategory(withName name: String) {
        dataProvider?.deleteCotegory(withName: name)
    }
}
