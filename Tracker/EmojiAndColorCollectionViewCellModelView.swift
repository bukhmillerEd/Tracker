
import UIKit

struct EmojiAndColorCollectionViewCellModelView {
    let typeCell: TypeCell
    let color: UIColor?
    let emoji: String
    var selectedColor: Bool
    var selectedemoji: Bool
}

enum TypeCell {
    case emoji
    case color
}
