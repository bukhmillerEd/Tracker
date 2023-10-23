import UIKit

final class PageOnboarding1: PageOnboarding {
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Отслеживайте только то, что хотите"
        imageView.image = UIImage(named: "onbording1")
    }
}
