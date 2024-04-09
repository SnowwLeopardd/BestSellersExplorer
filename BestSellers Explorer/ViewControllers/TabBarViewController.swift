//
//  TabBarViewController.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 2/29/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        setupVC()
        setupTabBarUI()
    }
    
    private func setupVC() {
        let quizVC = UINavigationController(rootViewController: QuizVC())
        let favoritesVC = UINavigationController(rootViewController: FavoritesVC())
        
        quizVC.tabBarItem.title = "TopBooks"
        quizVC.tabBarItem.image = UIImage(systemName: "books.vertical")
        
        favoritesVC.tabBarItem.title = "Favorites"
        favoritesVC.tabBarItem.image = UIImage(systemName: "star")
        
        setViewControllers([quizVC, favoritesVC], animated: true)
        
    }

    private func setupTabBarUI() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        
        tabBar.tintColor = .red
        tabBar.unselectedItemTintColor = .purple
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let selectedViewController = tabBarController.selectedViewController, selectedViewController == viewController {
            return false
        }
        return true
    }
}
