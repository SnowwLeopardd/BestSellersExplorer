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
        
        let restartAction = UIAlertAction(title: "Restart", style: .cancel) {_ in
            viewController.navigationController?.pushViewController(CalendarVC(), animated: true)
        }
        restartAction.isEnabled = false
        
        title == "Quota limit exceeded" ? alert.addAction(restartAction) : alert.addAction(okAction)
        
        var countdown = 20
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdown > 1 {
                countdown -= 1
                restartAction.setValue("Press restart in: (\(countdown))", forKey: "title")
            } else {
                timer.invalidate()
                restartAction.setValue("Restart", forKey: "title")
                restartAction.isEnabled = true
            }
        }
        
        viewController.present(alert, animated: true)
    }

    static func dismissAlert(alert: UIAlertController, completion: (() -> Void)? = nil) {
        alert.dismiss(animated: true, completion: completion)
    }
}

