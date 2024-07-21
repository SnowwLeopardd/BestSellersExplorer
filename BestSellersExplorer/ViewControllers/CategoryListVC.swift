//
//  CalendarViewController.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 1/22/24.
//

import UIKit

class CategoryListVC: UIViewController {
    
    private let tableView = UITableView()
    private let cellId = "ListCell"
    
    var delegate: CategoryListProtocol?
    
    private var sortedCategories: [List] = []
    private var activityIndicator: UIActivityIndicatorView?
    private var date: String
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    
    init(with date: String) {
        self.date = date
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
        view.backgroundColor = .white
        activityIndicator = ActivityIndicator.start(in: self.view,
                                                    topAnchorConstant: 200,
                                                    size: .large)
        fetchCategoriesData()
    }
    
    // MARK: - UIElements
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

extension CategoryListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let text = sortedCategories[indexPath.row].listName
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = sortedCategories[indexPath.row].listName
        delegate?.didSelectCategory(categoryName: selectedCategory)
        dismiss(animated: true)
    }
}

extension CategoryListVC {
    private func fetchCategoriesData() {
        let fullOverviewURL = Link.fullOverview(date: date).url
        
        networkManager.fetch(CategotyList.self, from: fullOverviewURL) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
            }
            switch result {
            case .success(let list):
                let sortedCategories = list.results.lists.sorted { $0.listName < $1.listName }
                self.sortedCategories = sortedCategories
                DispatchQueue.main.async {
                    self.setupTableView()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    switch error {
                    case .quotaLimitExceeded:
                        AlertController.showErrorAlert(on: self,
                                                       title: String(localized: "Quota limit exceeded"),
                                                       message: String(localized: "NY Times API blocks too many inquiries. Please, wait 20 seconds"))
                    default:
                        AlertController.showErrorAlert(on: self,
                                                       message: String(localized: "Error fetching data: \(error.localizedDescription)")
                                                       )
                    }
                }
            }
        }
    }
}

