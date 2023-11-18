import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersVC = TrackersViewController()
        let navigationController1 = UINavigationController(rootViewController: trackersVC)
        navigationController1.tabBarItem = UITabBarItem(title: NSLocalizedString("trackersVC.title", comment: ""),
                                                        image: UIImage(named: "trackers"),
                                                        tag: 0)

        let statisticsVC = StatisticsViewController()
        let navigationController2 = UINavigationController(rootViewController: statisticsVC)
        navigationController2.tabBarItem = UITabBarItem(title: NSLocalizedString("statisticsVC.title", comment: ""),
                                                        image: UIImage(named: "stats"),
                                                        tag: 1)
        
        viewControllers = [navigationController1, navigationController2]
    }
    
}
