//
//  CoreDataManagerProtocol.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/14/24.
//

import Foundation

protocol CoreDataManagerProtocol {
    func create(_ book: Book)
    func fetchData(completion: (Result<[FavoriteBook], Error>) -> Void)
    func delete(_ favoriteBook: FavoriteBook)
    func isUnique(_ primaryIsbn13: String) -> Bool
}
