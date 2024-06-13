//
//  FavoritesVC.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 2/29/24.
//

import UIKit

class FavoritesVC: UIViewController {
    
    var favoritesBooks: [FavoriteBook] = []
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFavoritesVC()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .favoriteBooksUpdated, object: nil)
    }
    
    private func setupFavoritesVC() {
        fetchData()
        setupTableViewUI()
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteBooksUpdated), name: .favoriteBooksUpdated, object: nil)
    }
    
    private func setupTableViewUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.register(FavoriteViewCell.self, forCellReuseIdentifier: "Book")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    @objc private func favoriteBooksUpdated() {
        fetchData()
        tableView.reloadData()
    }
}


