//
//  CoreDataProtocol.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/27/24.
//

import Foundation

protocol CoreDataManagerProtocol {
    func create(_ book: Book)
    func fetchData(completion: (Result<[FavoriteBook], Error>) -> Void)
    func deleteFavoriteBook(by primaryIsbn13: String)
    func fetchBook(_ primaryIsbn13: String) -> FavoriteBook?
    func delete(_ favoriteBook: FavoriteBook)
    func isUnique(_ primaryIsbn13: String) -> Bool
}
