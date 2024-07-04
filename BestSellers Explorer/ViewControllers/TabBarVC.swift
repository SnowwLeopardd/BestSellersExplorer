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
        appearance.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1.0)
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
                
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .black
    }
}

