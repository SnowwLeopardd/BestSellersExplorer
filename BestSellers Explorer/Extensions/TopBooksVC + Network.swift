//
//  TopBooksVC+Networking.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/12/24.
//
import UIKit

extension TopBooksVC {
    internal func fetchTopBestSellers() {
        let topBooksURL = Link.topBooksList(date: selectedDate, category: selectedCategory).url
        
        networkManager.fetch(TopBooksList.self, from: topBooksURL) { [weak self] result in
            switch result {
            case .success(let bestSellersList):
                let sortedBooks = bestSellersList.results.books.sorted { $0.rank < $1.rank }
                self?.sortedBooks = sortedBooks
                DispatchQueue.main.async {
                    self?.setupCollectionView()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    switch error {
                    case .quotaLimitExceeded:
                        guard let self = self else { return }
                        AlertController.showErrorAlert(on: self,
                                                       title: String(localized: "Quota limit exceeded"),
                                                       message: String(localized: "NY Times API blocks too many inquiries. Please, wait 20 seconds"))
                    default:
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
