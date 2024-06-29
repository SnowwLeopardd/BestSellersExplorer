//
//  CalendarViewController.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 1/22/24.
//

import UIKit

class CategoryListVC: UIViewController {
    
    private let tableView = UITableView()
    
    var delegate: CategoryListProtocol?
    
    internal var sortedCategories: [List] = []
    internal var activityIndocator: UIActivityIndicatorView?
    internal var date: String
    internal let networkManager: NetworkManagerProtocol = NetworkManager()
    
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
        navigationItem.hidesBackButton = true
        activityIndocator = ActivityIndicator.start(in: self.view,
                                                    topAnchorConstant: 200,
                                                    size: .large)
        fetchCategoriesData()
    }
    
    // MARK: - UIElements
    internal func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ListCell")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

