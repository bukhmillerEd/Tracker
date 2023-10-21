
enum TypeOperation {
    case newCategory
    case editingCategory(nameCategory: String)
}

struct CategoryViewModel {
        
    private let typeOperation: TypeOperation
    private let dataProvider: DataProvider?
    var nameBeforeEdit: String = ""
    
    var title: String {
        get {
            switch typeOperation {
            case .newCategory:
                return "Новая категория"
            case .editingCategory(_):
                return "Редактирование категории"
            }
        }
    }
    
    init(typeOperation: TypeOperation, nameForEdit: String) {
        self.typeOperation = typeOperation
        dataProvider = DataProviderForCoreData(delegate: nil)
        self.nameBeforeEdit = nameForEdit
    }
    
    func saveCategory(name: String) {
        switch typeOperation {
        case .newCategory:
            let _ = dataProvider?.addNewTrackerCategory(withTitle: name)
        case .editingCategory(_):
            dataProvider?.editTitleCategory(withName: nameBeforeEdit, newName: name)
        }
    }
}

