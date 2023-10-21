
struct CategoriesListViewModel {
    
    @Observable
    private(set) var categories: [CategoryListCellModel] = []
    
    private let categoriesListModel = CategoriesListModel()
    
    init() {
        getNameCategories()
    }
    
    func getNameCategories() {
        categories = categoriesListModel.getAllNamesCategories()
            .map{CategoryListCellModel(name: $0,
                                       isSelected: categoriesListModel.lastSelectedCategory == $0)}
    }
    
    func deleteCategory(withName name: String) {
        categoriesListModel.deleteCategory(withName: name)
        getNameCategories()
    }
    
    func didSelectedCategory(withName nameCategory: String) {
        categoriesListModel.lastSelectedCategory = nameCategory
    }
}
