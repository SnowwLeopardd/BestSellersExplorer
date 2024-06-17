//
//  FavoritesVC + CoreDaya.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/13/24.
//

import Foundation

extension FavoritesVC {
    internal func fetchData() {
        CoreDataManager.shared.fetchData { result in
            switch result {
            case .success(let favoritesBooks):
                self.favoritesBooks = favoritesBooks
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
