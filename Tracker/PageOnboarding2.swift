import UIKit

final class PageOnboarding2: PageOnboarding {
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = NSLocalizedString("onboarding2.text", comment: "Text on the second onboarding screen")
        imageView.image = UIImage(named: "onbording2")
    }
}
