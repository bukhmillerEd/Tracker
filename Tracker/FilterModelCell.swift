
import Foundation

struct FilterModelData: ModelCell {
    var name: String {
        get {
            typeFilter.getNameFilter()
        }
    }
    var isSelected: Bool
    let typeFilter: TypesFilters
}
