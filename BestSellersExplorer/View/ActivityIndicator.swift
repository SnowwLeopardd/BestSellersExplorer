//
//  ActivityIndicator.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/4/24.
//

import UIKit

class ActivityIndicator {
    
    static func start(in view: UIView, topAnchorConstant: CGFloat, size: UIActivityIndicatorView.Style = .medium ) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: size)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: topAnchorConstant),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        return activityIndicator
    }
}
