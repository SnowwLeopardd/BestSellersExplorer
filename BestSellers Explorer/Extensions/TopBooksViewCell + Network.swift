//
//  TopBooksViewCell + Network.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/12/24.
//
import UIKit

// MARK: - Networking
extension TopBooksViewCell {
    internal func fetchBookImage(from book: Book) {
        if let cacheImage = ImageCacheManager.shared.object(forKey: book.bookImage as NSString) {
            bookImageView.image = cacheImage
            activityIndicator?.stopAnimating()
            return
        }
        
        NetworkManager.shared.fetchImage(from: book.bookImage) { [weak self] result in
            switch result {
            case .success(let bookImage):
                guard let bookImage = UIImage(data: bookImage) else { return }
                self?.bookImageView.image = bookImage
                ImageCacheManager.shared.setObject(bookImage, forKey: book.bookImage as NSString)
                self?.activityIndicator?.stopAnimating()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
