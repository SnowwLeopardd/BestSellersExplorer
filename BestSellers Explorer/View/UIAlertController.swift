//
//  UIAlertController.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/4/24.
//

import UIKit

struct AlertController {

    static func showErrorAlert(on viewController: UIViewController, title: String = "Error", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive)
        alert.addAction(okAction)
        viewController.present(alert, animated: true)
    }

    static func showLoadingAlert(on viewController: UIViewController, title: String = "Loading", message: String = "\n") -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let activityIndicator = ActivityIndicator.start(in: alert.view, topAnchorConstant: 45, size: .medium)
        alert.view.addSubview(activityIndicator)
        
        viewController.present(alert, animated: true)
        return alert
    }

    static func dismissAlert(alert: UIAlertController, completion: (() -> Void)? = nil) {
        alert.dismiss(animated: true, completion: completion)
    }
}

