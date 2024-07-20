//
//  AboutMeVC.swift
//  BestSellersExplorer
//
//  Created by Aleksandr Bochkarev on 7/19/24.
//

import UIKit

class AboutMeVC: UIViewController {
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let jobExperienceLabel = UILabel()
    let bioTextView = UITextView()
    let contactButton = UIButton(type: .system)
    let versionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.9610984921, green: 0.9610984921, blue: 0.9610984921, alpha: 1)
        
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(jobExperienceLabel)
        view.addSubview(bioTextView)
        view.addSubview(contactButton)
        view.addSubview(versionLabel)
        
        setupProfileImageView()
        setupNameLabel()
        setupJobExperienceLabel()
        setupBioTextView()
        setupContactButton()
        setupVersionLabel()
    }
    
    private func setupProfileImageView() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 75
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.gray.cgColor
        profileImageView.image = UIImage(named: "MyPhoto")
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
        
    private func setupNameLabel() {
        nameLabel.text = "Alex Bochkarev"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupJobExperienceLabel() {
        jobExperienceLabel.text = "iOS Developer with Business Analysis background"
        jobExperienceLabel.font = UIFont.systemFont(ofSize: 18)
        jobExperienceLabel.numberOfLines = 0
        jobExperienceLabel.textAlignment = .center
        
        jobExperienceLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            jobExperienceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            jobExperienceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            jobExperienceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
        
    private func setupBioTextView() {
        bioTextView.text = """
        I am an iOS developer with mid-level expertise in UIKit and SwiftUI.
        
        My combined experience in business analysis (CJM, Lean Six Sigma), management (head of customer care/legal department) and law, makes me an ideal candidate for your start-up.
        
        I can bring a comprehensive view of customer pain points and effectively solve them through iOS platform solutions.
        """
        bioTextView.font = UIFont.systemFont(ofSize: 17)
        bioTextView.isEditable = false
        bioTextView.backgroundColor = #colorLiteral(red: 0.9610984921, green: 0.9610984921, blue: 0.9610984921, alpha: 1)
        
        bioTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bioTextView.topAnchor.constraint(equalTo: jobExperienceLabel.bottomAnchor, constant: 20),
            bioTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bioTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bioTextView.bottomAnchor.constraint(equalTo: contactButton.topAnchor, constant: -20),
        ])
    }
        
    private func setupContactButton() {
        contactButton.setTitle("Contact Me", for: .normal)
        contactButton.addTarget(self, action: #selector(contactButtonTapped), for: .touchUpInside)
        
        contactButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contactButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contactButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contactButton.bottomAnchor.constraint(equalTo: versionLabel.safeAreaLayoutGuide.bottomAnchor, constant: -25),
        ])
    }
    
    private func setupVersionLabel() {
        // Get the app version from the Info.plist
        if let infoDictionary = Bundle.main.infoDictionary,
           let version = infoDictionary["CFBundleShortVersionString"] as? String {
            versionLabel.text = "App version \(version)"
        } else {
            versionLabel.text = "Version not available"
        }

        versionLabel.font = UIFont.systemFont(ofSize: 14)
        versionLabel.textAlignment = .center
        versionLabel.textColor = .black
        
        versionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    @objc func contactButtonTapped() {
        let alert = UIAlertController(title: "Contact Me", message: "Email: s7604729700@gmail.com \nPhone: (760) 472-9700", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
