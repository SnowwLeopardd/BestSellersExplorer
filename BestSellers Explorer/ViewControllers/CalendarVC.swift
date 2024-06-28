//
//  CalendarVC.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 5/31/24.
//

import UIKit

class CalendarVC: UIViewController {
    
    private let calendarStack = UIStackView()
    
    private var descriptionHeader = UILabel()
    private var header = UILabel()
    private let chooseCategoryButton = UIButton()
    private let calendarView = UICalendarView()
    
    private let NYTimesLogo: UIImage
    private let NYTimesLogoImageView: UIImageView
    
    init() {
        NYTimesLogo = UIImage(named: "NYTimes Logo 1") ?? UIImage()
        NYTimesLogoImageView = UIImageView(image: NYTimesLogo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.9610984921, green: 0.9610984921, blue: 0.9610984921, alpha: 1)
        navigationItem.hidesBackButton = true
        
        headerLabel()
        descriptionHeaderLabel()
        setupChooseCategoryButton()
        setupCalendar()
        setupNYTimesImageView()
//        setupCalendarStack()
        

//        addShadow(to: header)
//        addShadow(to: descriptionHeader)
        addShadow(to: chooseCategoryButton)
        addShadow(to: calendarView)
        addShadow(to: NYTimesLogoImageView)
    }
    
    // MARK: - UIElements
    private func headerLabel() {
        header.text = "The New York Times Best Sellers"
        header.textColor = UIColor.black
        header.textAlignment = .left
        header.numberOfLines = 2
        header.font = UIFont.boldSystemFont(ofSize: 27)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
//            header.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func descriptionHeaderLabel() {
        descriptionHeader.text = "Authoritatively ranked lists of books sold in US. Select date and topics"
        descriptionHeader.textAlignment = .left
        descriptionHeader.numberOfLines = 2
        descriptionHeader.textColor = UIColor.black
        descriptionHeader.font = UIFont.systemFont(ofSize: 19)
        
        descriptionHeader.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionHeader)
        
        NSLayoutConstraint.activate([
            descriptionHeader.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 16),
            descriptionHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            descriptionHeader.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupChooseCategoryButton() {
        chooseCategoryButton.setTitle("Choose category", for: .normal)
        chooseCategoryButton.backgroundColor = UIColor.white
        chooseCategoryButton.setTitleColor(UIColor.lightGray, for: .normal)
        chooseCategoryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        chooseCategoryButton.layer.cornerRadius = 10
//        chooseCategoryButton.addTarget(self, action: #selector(setupAddToFavoriesLogic), for: .touchUpInside)
        
        view.addSubview(chooseCategoryButton)
        
        chooseCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chooseCategoryButton.topAnchor.constraint(equalTo: descriptionHeader.bottomAnchor, constant: 16),
            chooseCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            chooseCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            chooseCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupCalendar() {
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.backgroundColor = .white
//        calendarView.layer.borderColor = UIColor.lightGray.cgColor
//        calendarView.layer.borderWidth = 1.0
        calendarView.layer.cornerRadius = 10
//        calendarView.layer.masksToBounds = true
        
        view.addSubview(calendarView)
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: chooseCategoryButton.bottomAnchor, constant: 16),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: 380)
        ])
    }
    
    private func setupNYTimesImageView() {
        view.addSubview(NYTimesLogoImageView)
        
        NYTimesLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NYTimesLogoImageView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
            NYTimesLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Utility Function
    private func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false
    }
}
