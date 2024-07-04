//
//  CalendarVC.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 5/31/24.
//

import UIKit

class CalendarVC: UIViewController, CategoryListProtocol {
    
    private var descriptionHeader = UILabel()
    private var header = UILabel()
    internal let chooseCategoryButton = UIButton()
    internal let calendarView = UICalendarView()
    
    private let NYTimesLogo: UIImage
    private let NYTimesLogoImageView: UIImageView
    
    internal var choosenDate: String?
    
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
        
        setupCalendarRange()
        
        headerLabel()
        descriptionHeaderLabel()
        setupCalendar()
        setupChooseCategoryButton()
        setupNYTimesImageView()
        
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
        header.font = UIFont.boldSystemFont(ofSize: 34)
        
        view.addSubview(header)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func descriptionHeaderLabel() {
        descriptionHeader.text = "Authoritatively ranked lists of books sold in US. Select date and topics"
        descriptionHeader.textAlignment = .left
        descriptionHeader.numberOfLines = 2
        descriptionHeader.textColor = UIColor.gray
        descriptionHeader.font = UIFont.systemFont(ofSize: 19)
        
        view.addSubview(descriptionHeader)
        
        descriptionHeader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionHeader.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 16),
            descriptionHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupCalendar() {
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.backgroundColor = .white
        calendarView.layer.cornerRadius = 10
        
        view.addSubview(calendarView)
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: descriptionHeader.bottomAnchor, constant: 16),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: 380)
        ])
    }
    
    private func setupChooseCategoryButton() {
        chooseCategoryButton.setTitle("Please, choose above date first", for: .normal)
        chooseCategoryButton.backgroundColor = UIColor.white
        chooseCategoryButton.setTitleColor(UIColor.lightGray, for: .normal)
        chooseCategoryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        chooseCategoryButton.layer.cornerRadius = 10
        chooseCategoryButton.addTarget(self, action: #selector(presentCategoryListVC), for: .touchUpInside)
        
        view.addSubview(chooseCategoryButton)
        
        chooseCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chooseCategoryButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 16),
            chooseCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            chooseCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            chooseCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupNYTimesImageView() {
        view.addSubview(NYTimesLogoImageView)
        
        NYTimesLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NYTimesLogoImageView.topAnchor.constraint(equalTo: chooseCategoryButton.bottomAnchor, constant: 10),
            NYTimesLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    internal func didSelectCategory(categoryName: String) {
        chooseCategoryButton.setTitle(categoryName, for: .normal)
        guard let choosenDate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            let topBooksVC = TopBooksVC(selectedCategory: categoryName, selectedDate: choosenDate)
            self.navigationController?.pushViewController(topBooksVC, animated: true)
        }
    }
    
    @objc func presentCategoryListVC() {
        if let choosenDate = choosenDate {
            let destinationVC = CategoryListVC(with: choosenDate)
            destinationVC.delegate = self
            
            destinationVC.modalPresentationStyle = .pageSheet
            destinationVC.sheetPresentationController?.detents = [.medium()]
            destinationVC.sheetPresentationController?.prefersGrabberVisible = true
            present(destinationVC, animated: true)
        }
    }
    
    private func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false
    }
}
