//
//  FavoritesVC.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 2/29/24.
//

import UIKit

class FavoritesVC: UIViewController {
    
    var favoritesBooks: [FavoriteBook]!
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view = UITableView() - подумать над этим
        
        fetchData()
        setupTableViewUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // if faviritesBooks.hasChanged { do rest } - подумать
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Book", for: indexPath) as? FavoriteViewCell else {
            fatalError("Unable to dequeue FavoriteViewCell")
        }
        let favoriteBook = favoritesBooks[indexPath.row]
        cell.configure(with: favoriteBook)
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
        tableView.deselectRow(at: indexPath, animated: true)
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
