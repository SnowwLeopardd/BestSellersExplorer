//
//  CategoryListVC + Network.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/4/24.
//

import UIKit

// MARK: - NetWorking
extension CategoryListVC {
        internal func fetchCategoriesData() {
            print("This is date 2 \(date)")
            let url = Link.fullOverview.rawValue + date + "/" + Link.NYTimesApiKey.rawValue
            print(url)
            NetworkManager.shared.fetch(CategotyList.self, from: url ) { [weak self] result in
                switch result {
                case .success(let list):
                    let sortedCategories = list.results.lists.sorted { $0.listName < $1.listName }
                    self?.sortedCategories = sortedCategories
                    DispatchQueue.main.async {
                        self?.stopLoadingAlert()
                        self?.setupTableView()
                        self?.setQuizUI()
                    }
                case .failure(let error):
                    print("Error fetching data: \(error.localizedDescription)")
                }
            }
        }
    }
