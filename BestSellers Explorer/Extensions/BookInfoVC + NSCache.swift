//
//  BookInfoVC + NSCache.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/13/24.
//

import Foundation

extension BookInfoVC {
    internal func fetchBookImage(from book: Book) {
        let chacheImage = ImageCacheManager.shared.object(forKey: book.bookImage as NSString)
        bookImage.image = chacheImage
    }
}
