//
//  CoreDataProtocol.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/25/24.
//

import Foundation

protocol CoreDataProtocol {
    func create(_ book: Book)
    func fetchData(completion: (Result<[FavoriteBook], Error>) -> Void)
    func delete(_ favoriteBook: FavoriteBook)
    func isUnique(_ primaryIsbn13: String) -> Bool
}
