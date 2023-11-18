
import UIKit

final class StatisticsCell: UITableViewCell {
    
    static let cellID = "cellID"
    
    private lazy var countStatisticLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFPro-Bold", size: 34)
        return label
    }()
    
    private lazy var nameStatisticLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFPro-Medium", size: 12)
        return label
    }()
    
    private var gradientColors: [UIColor] = [
        UIColor.color(from: "FD4C49") ?? UIColor(),
        UIColor.color(from: "46E69D") ?? UIColor(),
        UIColor.color(from: "007BFA") ?? UIColor()
    ] {
        didSet {
            setNeedsLayout()
        }
    }
    
    func configure(model: StatisticsCellModel) {
        setData(model: model)
        addSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let gradient = UIImage.gradientImage(bounds: bounds, colors: gradientColors)
        layer.borderWidth = 1
        layer.borderColor = UIColor(patternImage: gradient).cgColor
        layer.cornerRadius = 16
    }
    
    private func setData(model: StatisticsCellModel) {
        countStatisticLabel.text = String(model.coutn)
        nameStatisticLabel.text = model.name
    }
    
    private func addSubviews() {
        contentView.addSubview(countStatisticLabel)
        contentView.addSubview(nameStatisticLabel)

        NSLayoutConstraint.activate([
            countStatisticLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countStatisticLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            countStatisticLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            countStatisticLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -37),

            nameStatisticLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameStatisticLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            nameStatisticLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            nameStatisticLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60)
        ])
    }
}


