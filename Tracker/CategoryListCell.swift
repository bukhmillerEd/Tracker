
import UIKit

final class CategoryListCell: UITableViewCell {
    static let idCell = "idCell"
    static let heightCell: CGFloat = 75
    
    private lazy var nameCategory = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separator = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ypGray")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var isSelectedCategory = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark")?.withTintColor(.blue)
        return imageView
    }()
    
    func configure(model: CategoryListCellModel, isLastCell: Bool, isFirstCell: Bool) {
        setData(model: model)
        addSubviews(isLastCell: isLastCell)
        contentView.backgroundColor = UIColor(named: "backgroundField")
    }
    
    private func addSubviews(isLastCell: Bool) {
        contentView.addSubview(isSelectedCategory)
        contentView.addSubview(nameCategory)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: Self.heightCell),
            
            isSelectedCategory.heightAnchor.constraint(equalToConstant: 24),
            isSelectedCategory.widthAnchor.constraint(equalToConstant: 24),
            isSelectedCategory.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            isSelectedCategory.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nameCategory.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameCategory.trailingAnchor.constraint(equalTo: isSelectedCategory.leadingAnchor, constant: -4),
            nameCategory.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        if !isLastCell {
            contentView.addSubview(separator)
            NSLayoutConstraint.activate([
                separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: 1)
            ])
        } else {
            separator.removeFromSuperview()
        }
    }
    
    private func setData(model: CategoryListCellModel) {
        nameCategory.text = model.name
        isSelectedCategory.isHidden = !model.isSelected
    }
}
