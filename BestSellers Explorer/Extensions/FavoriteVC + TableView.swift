//
//  FavoriteVC + TableView.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/13/24.
//

import UIKit

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
        return String(localized: "Favorites Books")
    }
    
    // MARK: - UITableViewDelegate
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
        let deleteAction = UIContextualAction(style: .destructive, title: String(localized: "Delete")) { [unowned self] _, _, _ in
            self.favoritesBooks.remove(at: indexPath.row)
            coreDataManager.delete(selectedBook)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            NotificationCenter.default.post(name: .favoriteBooksUpdated, object: nil)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
