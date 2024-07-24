//
//  FavoritesVC.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 2/29/24.
//

import UIKit

class FavoritesVC: UIViewController {
    
    private var favoritesBooks: [FavoriteBook] = []
    private let tableView = UITableView()
    private let cellId = "Book"
    private let emptyLabel = UILabel()
    private let coreDataManager: CoreDataManagerProtocol = CoreDataManager()
    
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
        setupEmptyLabelUI()
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteBooksUpdated), name: .favoriteBooksUpdated, object: nil)
    }
    
    @objc private func favoriteBooksUpdated() {
        fetchData()
        tableView.reloadData()
    }
    
    private func setupTableViewUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.register(FavoriteViewCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func setupEmptyLabelUI() {
        emptyLabel.text = String(localized: "FavoritesVC_Add books_to_Favorites")
        emptyLabel.textAlignment = .center
        emptyLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        emptyLabel.textColor = .gray
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateEmptyLabelVisibility() {
        DispatchQueue.main.async {
            self.emptyLabel.isHidden = !self.favoritesBooks.isEmpty
        }
    }
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? FavoriteViewCell else {
            fatalError("Unable to dequeue FavoriteViewCell")
        }
        let favoriteBook = favoritesBooks[indexPath.row]
        cell.configure(with: favoriteBook)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(localized: "FavoritesVC_Favorites_Books")
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        configureHeader(view: header)
    }
    
    private func configureHeader(view: UITableViewHeaderFooterView) {
        view.textLabel?.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        view.textLabel?.numberOfLines = 0
        view.textLabel?.lineBreakMode = .byWordWrapping
        view.textLabel?.textColor = UIColor.black
        view.sizeToFit()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = favoritesBooks[indexPath.row]
       
        let convertedBook = Book(rank: Int(selectedBook.rank),
             primaryIsbn13: selectedBook.primaryIsbn13 ?? "",
             description: selectedBook.about ?? "",
             title: selectedBook.title ?? "",
             author: selectedBook.author ?? "",
             bookImage: selectedBook.imageUrl ?? ""
        )
        
        let bookInfoVC = BookInfoVC(book: convertedBook)
        navigationController?.pushViewController(bookInfoVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedBook = favoritesBooks[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: String(localized: "FavoritesVC_Delete")) { [unowned self] _, _, _ in
            self.favoritesBooks.remove(at: indexPath.row)
            coreDataManager.delete(selectedBook)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            NotificationCenter.default.post(name: .favoriteBooksUpdated, object: nil)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension FavoritesVC {
    private func fetchData() {
        coreDataManager.fetchData { [weak self] result in
            switch result {
            case .success(let favoritesBooks):
                self?.favoritesBooks = favoritesBooks
                self?.updateEmptyLabelVisibility()
            case .failure(let error):
                guard let self else { return }
                DispatchQueue.main.async {
                    AlertController.showErrorAlert(on: self,
                                                   message: "\(error.localizedDescription)")
                }
            }
        }
    }
}
