//
//  LoadJson.swift
//  BestSellersExplorerTests
//
//  Created by Aleksandr Bochkarev on 7/21/24.
//

import Foundation

extension Bundle {
    func loadJson<T: Decodable>(fromResource resource: String) -> T? {
        guard let url = self.url(forResource: resource, withExtension: "json"),
              let jsonData = try? Data(contentsOf: url) else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let items = try decoder.decode(T.self, from: jsonData)
            return items
        } catch {
            print("Error decoding the JSON: \(error)")
            return nil
        }
    }
}
