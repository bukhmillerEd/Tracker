import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersVC = TrackersViewController()
        trackersVC.tabBarItem = UITabBarItem(title: "Трекеры",
                                             image: UIImage(named: "trackers"),
                                             tag: 0)
        
        let statisticsVC = StatisticsViewController()
        statisticsVC.tabBarItem = UITabBarItem(title: "Статистика",
                                               image: UIImage(named: "stats"),
                                               tag: 1)
        let navigationController = UINavigationController()
        navigationController.viewControllers = [trackersVC]
        self.viewControllers = [navigationController, statisticsVC]
    }
    
}
