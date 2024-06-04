//
//  UIAlertController.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/4/24.
//
import UIKit

extension CategoryListVC {
    internal func showLoadingAlert() {
        let activityIndicator = ActivityIndicator.start(in: alertController.view, topAnchorConstant: 45)
        
        present(alertController, animated: true) {
            activityIndicator.startAnimating()
        }
    }
    
    internal func stopLoadingAlert() {
        alertController.dismiss(animated: true)
    }
}






//extension CategoryListVC {
//    private func showLoadingAlert() {
//        let activityIndicator = UIActivityIndicatorView(style: .medium)
//        
//        alertController.view.addSubview(activityIndicator)
//        
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            activityIndicator.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 45),
//            activityIndicator.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor)
//        ])
//        
//        activityIndicator.startAnimating()
//        
//        present(alertController, animated: true)
//    }
//    
//    private func hideLoadingAlert() {
//        alertController.dismiss(animated: true)
//    }
//}
