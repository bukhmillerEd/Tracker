import UIKit

final class PageOnboarding1: PageOnboarding {
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = NSLocalizedString("onboarding1.text", comment: "Text on the first onboarding screen")
        imageView.image = UIImage(named: "onbording1")
    }
}
