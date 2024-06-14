//
//  CategoryListVC + Network.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/4/24.
//

import UIKit

// MARK: - Networking
extension CategoryListVC {
    internal func fetchCategoriesData() {
        let fullOverviewURL = Link.fullOverview(date: date).url
        print(fullOverviewURL)
        NetworkManager.shared.fetch(CategotyList.self, from: fullOverviewURL) { [weak self] result in
            switch result {
            case .success(let list):
                let sortedCategories = list.results.lists.sorted { $0.listName < $1.listName }
                self?.sortedCategories = sortedCategories
                DispatchQueue.main.async {
                    self?.activityIndocator?.stopAnimating()
                    self?.setupTableView()
                    self?.setQuizUI()
                }
            case .failure(let error):
                switch error {
                case .quotaLimitExceeded:
                    print("Quota limit exceeded. Please try again later.")
                    DispatchQueue.main.async {
                        self?.activityIndocator?.stopAnimating()
                        guard let self = self else { return }
                        AlertController.showErrorAlert(on: self,
                                                       title: "Quota limit exceeded",
                                                       message: "Quota limit exceeded. Please try again later.")
                    }
                default:
                    print("Error fetching data: \(error.localizedDescription)")
                }
            }
        }
    }
}
