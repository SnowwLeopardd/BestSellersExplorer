//
//  AboutMeVC.swift
//  BestSellersExplorer
//
//  Created by Aleksandr Bochkarev on 7/19/24.
//

import UIKit

class AboutMeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    private let cellID = "cell"
    
    private let titleName = String(localized: "AboutMeVC_title")
    private let email = String(localized: "AboutMeVC_email")
    private let phoneNumber = String(localized: "AboutMeVC_phoneNumber")
    private let aboutMe = String(localized: "AboutMeVC_about_me")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = titleName
        
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        view.addSubview(tableView)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = aboutMe
            cell.textLabel?.textAlignment = .justified
            cell.textLabel?.numberOfLines = 0
        case 1:
            if indexPath.row == 0 {
                cell.textLabel?.text = String(localized: "AboutMeVC_Email:_\(email)")
            } else if indexPath.row == 1 {
                cell.textLabel?.text = String(localized: "AboutMeVC_Phone:_\(phoneNumber)")
            }
        default:
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return String(localized: "AboutMeVC_section_one_header")
        case 1:
            return String(localized: "AboutMeVC_section_two_header")
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if let emailURL = URL(string: "mailto:\(email)"),
                    UIApplication.shared.canOpenURL(emailURL) 
                {
                    UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
                }
            } else if indexPath.row == 1 {
                if let phoneURL = URL(string: "tel://\(phoneNumber)"), 
                    UIApplication.shared.canOpenURL(phoneURL)
                {
                    UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
