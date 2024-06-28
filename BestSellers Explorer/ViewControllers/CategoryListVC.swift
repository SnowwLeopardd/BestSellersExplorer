//
//  CalendarViewController.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 1/22/24.
//

import UIKit

class CategoryListVC: UIViewController {
    private let tableView = UITableView()
    
    private let questionLabel = UILabel()
    
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
                                                    topAnchorConstant: 400,
                                                    size: .large)
        fetchCategoriesData()
        setupQuestionLabel()
    }
    
    // MARK: - UIElements
    private func setupQuestionLabel() {
        questionLabel.text = "Pick something"
        questionLabel.textColor = UIColor.purple
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.boldSystemFont(ofSize: 27)
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(questionLabel)
        
        NSLayoutConstraint.activate([
            questionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            questionLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    internal func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ListCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

