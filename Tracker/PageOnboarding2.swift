import UIKit

final class PageOnboarding2: PageOnboarding {
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Даже если это не литры воды и йога"
        imageView.image = UIImage(named: "onbording2")
    }
}
