import UIKit

final class Colors {
    
    static let systemBackgroundColor = UIColor.systemBackground
    
    static let viewBackgroundColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return .black
        } else {
            return .white
        }
    }
    
    static let colorText = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return .white
        } else {
            return .black
        }
    }
}
