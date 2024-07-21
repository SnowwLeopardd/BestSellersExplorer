//
//  CoreDataProtocol.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/27/24.
//

import Foundation

protocol CoreDataManagerProtocol {
    func createFavoriteBook(from book: Book)
    func fetchData(completion: (Result<[FavoriteBook], Error>) -> Void)
    func deleteFavoriteBook(by primaryIsbn13: String, completion: (Result<Void, Error>) -> Void)
    func delete(_ favoriteBook: FavoriteBook)
    func isUnique(_ primaryIsbn13: String ,completion: (Result<Bool, Error>) -> Void)
}
