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
            DispatchQueue.main.async {
                self.bookImageView.image = cacheImage
                self.activityIndicator?.stopAnimating()
            }
            return
        }
        
        networkManager.fetchImage(from: book.bookImage) { [weak self] result in
            switch result {
            case .success(let bookImage):
                guard let bookImage = UIImage(data: bookImage) else { return }
                DispatchQueue.main.async {
                    self?.bookImageView.image = bookImage
                    self?.activityIndicator?.stopAnimating()
                }
                ImageCacheManager.shared.setObject(bookImage, forKey: book.bookImage as NSString)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
