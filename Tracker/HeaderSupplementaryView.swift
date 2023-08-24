import UIKit

final class FooterSupplementaryView: UICollectionReusableView {
    
    static let footerId = "footer"
    
    private lazy var stackViews: UIStackView = {
        let stackViews = UIStackView()
        stackViews.translatesAutoresizingMaskIntoConstraints = false
        stackViews.axis = .horizontal
        stackViews.spacing = 8
        stackViews.backgroundColor = .red
        return stackViews
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        appViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func appViews() {
        addSubview(stackViews)
        
        NSLayoutConstraint.activate([
            stackViews.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackViews.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackViews.topAnchor.constraint(equalTo: topAnchor),
            stackViews.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
