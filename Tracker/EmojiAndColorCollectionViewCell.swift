import UIKit

enum TypeCell {
    case emoji
    case color
}

final class EmojiAndColorCollectionViewCell: UICollectionViewCell {
    
    static let idCell = "idCell"
    
    private var typeCell = TypeCell.color
    priv
    
    private let emojiLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "SFPro-Bold", size: 32)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 16
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(emojiLabel)
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    func configure(typeCell: TypeCell, emoji: String, color: UIColor?) {
        if typeCell == .color {
            colorView.backgroundColor = color
            colorView.isHidden = false
        } else {
            emojiLabel.text = emoji
        }
    }
    
    func selectCell(typeCell: TypeCell) {
        if typeCell == .emoji {
            layer.cornerRadius = 16
            backgroundColor = UIColor(named: "ypLightGray")
        } else {
            layer.borderWidth = 3
            layer.cornerRadius = 8
            layer.borderColor =
        }
    }
}
