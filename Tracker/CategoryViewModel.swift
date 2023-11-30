import Foundation

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
                return NSLocalizedString("category.title.newCategory", comment: "Title on the screen new category")
            case .editingCategory(_):
                return NSLocalizedString("category.edit.title", comment: "Title on the screen editing category")
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

