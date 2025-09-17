//
//  MainTabBarController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTabBar()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "tabbar")
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "active")
        appearance.stackedLayoutAppearance.normal.iconColor = .systemGray3
        
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        
        UITabBar.appearance().itemPositioning = .centered
        UITabBar.appearance().unselectedItemTintColor = .gray
        UITabBar.appearance().tintColor = .blue

        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .selected)
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBarItem.title = nil
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
    
    private func setupTabBar() {
        let homeViewController = setupHomeViewController()
        let searchViewController = setupSearchViewController()
        let trackedItemsViewController = setupTrackedItemsViewController()
        
        viewControllers = [homeViewController, searchViewController, trackedItemsViewController]
    }
}

private extension MainTabBarController {
    
    // MARK: - View Controllers
    
    func setupHomeViewController() -> UIViewController {
        let viewController = HomeViewController()
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.tabBarItem.image = UIImage(systemName: "safari")
        
        return navigationController
    }
    
    func setupSearchViewController() -> UIViewController {
        let viewController = SearchViewController()
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        return navigationController
    }
    
    func setupTrackedItemsViewController() -> UIViewController {
        let viewController = TrackedItemsController()
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.tabBarItem.image = UIImage(systemName: "checklist")
        
        return navigationController
    }
}
