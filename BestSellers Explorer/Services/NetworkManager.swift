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
}

enum Link: String {
    case NYTimesApiKey = ".json?api-key=AkNsiAR3NZkyJqlUX98Xh4ExBrFX42Al"
    
    //https://api.nytimes.com/svc/books/v3/lists/{date}/{list}
    case TopBooksList = "https://api.nytimes.com/svc/books/v3/lists/"
    
    case fullOverview = "https://api.nytimes.com/svc/books/v3/lists/full-overview/"
    
    case bookReview = "https://api.nytimes.com/svc/books/v3/reviews/"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T:Decodable>(_ type: T.Type, from url: String?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string:  url ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                print(data)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    
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
