
import UIKit

class ViewCell: UITableViewCell {
    static let idCell = "idCell"
    static let heightCell: CGFloat = 75
    
    private lazy var name = {
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
    
    private lazy var isSelectedRow = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark")?.withTintColor(.blue)
        return imageView
    }()
    
    func configure(model: ModelCell, isLastCell: Bool, isFirstCell: Bool) {
        setData(model: model)
        addSubviews(isLastCell: isLastCell)
        contentView.backgroundColor = UIColor(named: "backgroundField")
    }
    
    private func addSubviews(isLastCell: Bool) {
        contentView.addSubview(isSelectedRow)
        contentView.addSubview(name)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: Self.heightCell),
            
            isSelectedRow.heightAnchor.constraint(equalToConstant: 24),
            isSelectedRow.widthAnchor.constraint(equalToConstant: 24),
            isSelectedRow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            isSelectedRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            name.trailingAnchor.constraint(equalTo: isSelectedRow.leadingAnchor, constant: -4),
            name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
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
    
    private func setData(model: ModelCell) {
        name.text = model.name
        isSelectedRow.isHidden = !model.isSelected
    }
}
