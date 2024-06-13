//
//  TabBarViewController.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 2/29/24.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabBar()
    }
    
    private func setupTabBar() {
        setupViewControllers()
        setupTabBarAppearance()
    }
    
    private func setupViewControllers() {
        let calendarVC = UINavigationController(rootViewController: CalendarVC())
        let favoritesVC = UINavigationController(rootViewController: FavoritesVC())
        
        configureTabBarItem(for: calendarVC, withTitle: "TopBooks", andImage: UIImage(systemName: "books.vertical"))
        configureTabBarItem(for: favoritesVC, withTitle: "Favorites", andImage: UIImage(systemName: "star"))
        
        setViewControllers([calendarVC, favoritesVC], animated: true)
    }
    
    private func configureTabBarItem(for viewController: UIViewController, withTitle title: String, andImage image: UIImage?) {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        
        tabBar.tintColor = .red
        tabBar.unselectedItemTintColor = .purple
    }
}

