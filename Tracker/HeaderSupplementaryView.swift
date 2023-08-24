import UIKit

final class HeaderSupplementaryView: UICollectionReusableView {
    
    static let headerId = "header"
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFPro-Bold", size: 19)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        appViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func appViews() {
        addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func configure(headerText: String) {
        headerLabel.text = headerText
    }
}
