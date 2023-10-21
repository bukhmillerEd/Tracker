
class CategoriesListModel {
  
    private var dataProvider: DataProviderForCoreData?
    
    init() {
        self.dataProvider = DataProviderForCoreData(delegate: nil)
    }
    
    func getAllNamesCategories() -> [String] {
        return dataProvider?.getAllNamesCategories() ?? []
    }
}
