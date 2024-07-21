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
    let calendarView = UICalendarView()
    private let NYTimesLogo: UIImage
    private let NYTimesLogoImageView: UIImageView
    private let initialDate = "2019-01-01"
    
    var choosenDate: String?
    private var dateSelection: UICalendarSelectionSingleDate?

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
        setupNYTimesImageView()
        
        addShadow(to: calendarView)
        addShadow(to: NYTimesLogoImageView)
    }
    
    // MARK: - UIElements
    private func headerLabel() {
        header.text = String(localized: "The New York Times Best Sellers")
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
        descriptionHeader.text = String(localized: "Authoritatively ranked lists of books sold in US. Select date and topics")
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
        
        dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: descriptionHeader.bottomAnchor, constant: 32),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupNYTimesImageView() {
        view.addSubview(NYTimesLogoImageView)
        
        NYTimesLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NYTimesLogoImageView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 32),
            NYTimesLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false
    }
    
    func presentCategoryListVC() {
        if let choosenDate = choosenDate {
            let destinationVC = CategoryListVC(with: choosenDate)
            destinationVC.delegate = self
            
            destinationVC.modalPresentationStyle = .pageSheet
            destinationVC.sheetPresentationController?.detents = [.medium()]
            destinationVC.sheetPresentationController?.prefersGrabberVisible = true
            present(destinationVC, animated: true) {
                self.dateSelection?.selectedDate = nil
            }
        }
    }
    
    func didSelectCategory(categoryName: String) {
        guard let choosenDate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let topBooksVC = TopBooksVC(selectedCategory: categoryName, selectedDate: choosenDate)
            self.navigationController?.pushViewController(topBooksVC, animated: true)
        }
    }
}

extension CalendarVC: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        choosenDate = dateToString(dateComponents)
        presentCategoryListVC()
    }
    
    func dateToString(_ dateComponents: DateComponents?) -> String {
        guard let dateComponents else { return String(localized: "no date") }
        let date = Calendar.current.date(from: dateComponents) ?? Date()
        return AppDateFormatter.shared.string(from: date)
    }
    
    func setupCalendarRange() {
        let startDate = AppDateFormatter.shared.date(from: initialDate) ?? Date(timeIntervalSince1970: 0)
        let endDate = Date()
        let calendarViewDateRange = DateInterval(start: startDate, end: endDate)
        calendarView.availableDateRange = calendarViewDateRange
    }
}
