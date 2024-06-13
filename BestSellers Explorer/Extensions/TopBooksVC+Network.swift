//
//  TopBooksVC+Networking.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/12/24.
//
import UIKit

// FIXME: - add NSCacheManager
// MARK: - FetchData
extension TopBooksVC {
    internal func fetchTopBestSellers() {
        print(selectedCategory)
        print(selectedDate)
        let url = Link.TopBooksList.rawValue + selectedDate + "/" + selectedCategory + Link.NYTimesApiKey.rawValue
        print(url)
        NetworkManager.shared.fetch(TopBooksList.self, from: url) { [weak self] result in
            switch result {
            case .success(let bestSellersList):
                let sortedBooks = bestSellersList.results.books.sorted { $0.rank < $1.rank }
                self?.sortedBooks = sortedBooks
                    DispatchQueue.main.async {
                        self?.setupCollectionView()
                    }
            case .failure(let error):
                switch error {
                case .quotaLimitExceeded:
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        AlertController.showErrorAlert(on: self,
                                                       title: "Quota limit exceeded",
                                                       message: "NY Times API blocks too many inquiries. Please, wait 20 seconds")
                    }
                default:
                    print(error.localizedDescription)
                }

            }
        }
    }
}
