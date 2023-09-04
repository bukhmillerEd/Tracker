
import UIKit

struct EmojiAndColorCollectionViewCellModelView {
    let typeCell: TypeCell
    let color: UIColor?
    let emoji: String
}

enum TypeCell {
    case emoji
    case color
}
