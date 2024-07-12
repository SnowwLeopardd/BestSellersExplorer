//
//  TabBarVC + Delegate.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/12/24.
//

import UIKit

extension TabBarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let selectedViewController = tabBarController.selectedViewController, selectedViewController == viewController {
            return false
        }
        return true
    }
}
