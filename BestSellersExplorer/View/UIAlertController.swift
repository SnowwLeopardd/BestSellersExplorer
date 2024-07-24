//
//  UIAlertController.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/4/24.
//

import UIKit

struct AlertController {

    static func showErrorAlert(on viewController: UIViewController, title: String = String(localized: "UIAlertController_Error"), message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: String(localized: "UIAlertController_OK"), style: .destructive)
        
        let restartAction = UIAlertAction(title: String(localized: "UIAlertController_Wait_for_timer"), style: .cancel) { _ in
            viewController.dismiss(animated: true)
            viewController.navigationController?.popToRootViewController(animated: true)
        }
        restartAction.isEnabled = false
        
        title == String(localized: "UIAlerController_Quota_limit_exceeded") ? alert.addAction(restartAction) : alert.addAction(okAction)
        
        var countdown = 20
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdown > 1 {
                countdown -= 1
                restartAction.setValue(String(localized: "UIAlertController_Press_restart_in: (\(countdown))_seconds"), forKey: "UIAlertController_title")
            } else {
                timer.invalidate()
                restartAction.setValue(String(localized: "UIAlertController_Restart"), forKey: "UIAlertController_title")
                restartAction.isEnabled = true
            }
        }
        viewController.present(alert, animated: true)
    }

    static func dismissAlert(alert: UIAlertController, completion: (() -> Void)? = nil) {
        alert.dismiss(animated: true, completion: completion)
    }
}

