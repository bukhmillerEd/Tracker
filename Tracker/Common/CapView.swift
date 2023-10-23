import UIKit

final class CapView: UIView {
    
    private lazy var capStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private lazy var capImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.image = UIImage(named: "imageCup")
        imageView.contentMode = .center
        return imageView
    }()

    lazy var capText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFPro-Medium", size: 12)
        label.contentMode = .center
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addSubviews() {
        capStackView.addArrangedSubview(capImageView)
        capStackView.addArrangedSubview(capText)
        addSubview(capStackView)
        
        NSLayoutConstraint.activate([
    
            capStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            capStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}



