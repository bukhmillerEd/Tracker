
import UIKit

final class OnboardingViewController: UIPageViewController {
    private lazy var pages: [PageOnboarding] = {
        return [PageOnboarding1(), PageOnboarding2()]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .black.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        transitionStyle
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true)
        }
        addSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168)
        ])
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? PageOnboarding,
              let viewControllerIndex = pages.firstIndex(of: vc) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? PageOnboarding,
              let viewControllerIndex = pages.firstIndex(of: vc) else {
            return nil
        }
        let previousIndex = viewControllerIndex + 1
        guard previousIndex < pages.count else {
            return nil
        }
        return pages[previousIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool)
    {
        if let currentViewController = pageViewController.viewControllers?.first as? PageOnboarding,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
