import UIKit

extension UIStackView {
    func addSeparator(color: UIColor, thickness: CGFloat, index: Int) {
        let separator = UIView()
        separator.backgroundColor = color
        separator.translatesAutoresizingMaskIntoConstraints = false
        insertArrangedSubview(separator, at: index)
        
        separator.heightAnchor.constraint(equalToConstant: thickness).isActive = true
    }
    
    func addSeparators(color: UIColor, thickness: CGFloat) {
        for index in stride(from: arrangedSubviews.count - 1, through: 1, by: -1) {
            addSeparator(color: color, thickness: thickness, index: index)
        }
    }
}

