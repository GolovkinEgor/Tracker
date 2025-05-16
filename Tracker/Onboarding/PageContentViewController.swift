//
//  PageContentViewController.swift
//  Tracker
//
//  Created by Golovkin Egor on 09.05.2025.
//


import UIKit

final class OnboardingPageViewController: UIPageViewController {
    
    private lazy var pages: [OnboardingViewController] = {
        let pageBlue = OnboardingViewController(imageName: "onboarding1Illustration", descriptionLabel: NSLocalizedString("onboarding_page1_desc", comment: "Описание первого экрана онбординга"))
        let pageRed = OnboardingViewController(imageName: "onboarding2Illustration", descriptionLabel: NSLocalizedString("onboarding_page2_desc", comment: "Описание второго экрана онбординга"))
        
        pageBlue.button.addTarget(self, action: #selector(finishOnboarding), for: .touchUpInside)
        pageRed.button.addTarget(self, action: #selector(finishOnboarding), for: .touchUpInside)
        return [pageBlue, pageRed]
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    
    private var currentIndex = 0
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setViewControllers([pages[0]], direction: .forward, animated: true)
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])

    }
    
    @objc private func finishOnboarding() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.completeOnboarding()
        }

        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let mainVC = TabBarController()
            sceneDelegate.changeRootViewController(mainVC)
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! OnboardingViewController), index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! OnboardingViewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed,
           let currentVC = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: currentVC as! OnboardingViewController) {
            currentIndex = index
            pageControl.currentPage = index
        }
    }

}
