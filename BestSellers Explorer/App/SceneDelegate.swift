//
//  SceneDelegate.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 4/8/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    // to set first viewController by default
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        // make window visible
        window?.makeKeyAndVisible()
        // make window initiate viewController
        window?.rootViewController = UINavigationController(rootViewController: ViewController())
    }
}
