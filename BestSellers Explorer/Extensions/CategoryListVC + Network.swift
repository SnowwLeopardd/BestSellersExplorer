//
//  CategoryListVC + Network.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/4/24.
//

import UIKit

extension CategoryListVC {
    internal func fetchCategoriesData() {
        let fullOverviewURL = Link.fullOverview(date: date).url
        
        networkManager.fetch(CategotyList.self, from: fullOverviewURL) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
            }
            switch result {
            case .success(let list):
                let sortedCategories = list.results.lists.sorted { $0.listName < $1.listName }
                self.sortedCategories = sortedCategories
                DispatchQueue.main.async {
                    self.setupTableView()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    switch error {
                    case .quotaLimitExceeded:
                        AlertController.showErrorAlert(on: self,
                                                       title: String(localized: "Quota limit exceeded"),
                                                       message: String(localized: "NY Times API blocks too many inquiries. Please, wait 20 seconds"))
                    default:
                        print("Error fetching data: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
