import UIKit

final class TabBarController: UITabBarController {
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.separatorTabBarColor
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        
        let trackersVC = TrackersViewController()
        let navigationController1 = UINavigationController(rootViewController: trackersVC)
        navigationController1.tabBarItem = UITabBarItem(title: NSLocalizedString("trackersVC.title", comment: ""),
                                                        image: UIImage(named: "trackers"),
                                                        tag: 0)

        let statisticsVC = StatisticsViewController(viewModel: StatisticsViewModel())
        let navigationController2 = UINavigationController(rootViewController: statisticsVC)
        navigationController2.tabBarItem = UITabBarItem(title: NSLocalizedString("statisticsVC.title", comment: ""),
                                                        image: UIImage(named: "stats"),
                                                        tag: 1)
        
        viewControllers = [navigationController1, navigationController2]
    }
    
    private func addSubviews() {
        tabBar.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            separatorView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            separatorView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
