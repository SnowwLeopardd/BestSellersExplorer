//
//  FavoritesVC.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 2/29/24.
//

import UIKit

class FavoritesVC: UIViewController {
    
    static let shared = FavoritesVC()
    
    var favoritesBooks: [FavoriteBook]!
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupTableViewUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
    }
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Book", for: indexPath)
        let title = favoritesBooks[indexPath.row].title
        cell.textLabel?.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favorites Books"
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        configureHeader(view: header)
    }
    
    private func configureHeader (view: UITableViewHeaderFooterView) {
        view.textLabel?.font = UIFont(name: "Verdana-Italic", size: 24)
        view.textLabel?.numberOfLines = 0
        view.textLabel?.lineBreakMode = .byWordWrapping
        view.textLabel?.textColor = UIColor.black
        view.sizeToFit()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = favoritesBooks[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedBook = favoritesBooks[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            self.favoritesBooks.remove(at: indexPath.row)
            CoreDataManager.shared.delete(selectedBook)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func setupTableViewUI() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Book")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    // TODO: - Create emply "Welcome list" when this is no favorites books in Core Data.
}

extension FavoritesVC {
    private func fetchData() {
        CoreDataManager.shared.fetchData { result in
            switch result {
            case .success(let favoritesBooks):
                self.favoritesBooks = favoritesBooks
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
