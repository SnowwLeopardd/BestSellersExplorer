//
//  FavoriteViewCell + Network.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/28/24.
//
import UIKit

extension FavoriteViewCell {
    internal func fetchBookImage(from url: String) {
        if let cacheImage = ImageCacheManager.shared.object(forKey: url as NSString) {
            bookImageView.image = cacheImage
            self.activityIndicator.stopAnimating()
            return
        }
        
        networkManager.fetchImage(from: url) { result in
            switch result {
            case .success(let bookImage):
                guard let extractedImage = UIImage(data: bookImage) else { return }
                DispatchQueue.main.async {
                    self.bookImageView.image = extractedImage
                    ImageCacheManager.shared.setObject(extractedImage, forKey: url as NSString)
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
