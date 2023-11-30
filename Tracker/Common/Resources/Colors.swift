import UIKit

final class Colors {
    
    static let systemBackgroundColor = UIColor.systemBackground
    
    static let viewBackgroundColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.color(from: "1A1B22") ?? .black
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
    
    static let separatorTabBarColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.color(from: "AEAFB4") ?? .black
        } else {
            return .black
        }
    }
}
