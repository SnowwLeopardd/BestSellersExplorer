//
//  NetworkManager.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 1/22/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case quotaLimitExceeded
}

enum Link {
    case topBooksList(date: String, category: String)
    case fullOverview(date: String)
    
    var url: String {
        switch self {
        case .topBooksList(let date, let category):
            return "https://api.nytimes.com/svc/books/v3/lists/\(date)/\(category).json?api-key=AkNsiAR3NZkyJqlUX98Xh4ExBrFX42Al"
        case .fullOverview(let date):
            return "https://api.nytimes.com/svc/books/v3/lists/full-overview/\(date).json?api-key=AkNsiAR3NZkyJqlUX98Xh4ExBrFX42Al"
        }
    }
}

class NetworkManager: NetworkManagerProtocol {
}

extension NetworkManager {
    func fetch<T: Decodable>(_ type: T.Type, from url: String?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            // Handle rate limit exceeded error
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let fault = json["fault"] as? [String: Any],
               let faultString = fault["faultstring"] as? String,
               faultString.contains("Rate limit quota violation") {
                completion(.failure(.quotaLimitExceeded))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

extension NetworkManager {
    func fetchImage(from url: String?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
}
