//
//  MockNetworkManager.swift
//  BestSellers ExplorerTests
//
//  Created by Aleksandr Bochkarev on 6/25/24.
//

import XCTest
@testable import BestSellers_Explorer

class MockNetworkManager: NetworkManagerProtocol {
    
    var shoudReturnError = false
    var mockedImageData: Data?
    
    func fetch<T>(_ type: T.Type, from url: String?, completion: @escaping (Result<T, BestSellers_Explorer.NetworkError>) -> Void) where T : Decodable {
    }
    
    func fetchImage(from url: String?, completion: @escaping (Result<Data, BestSellers_Explorer.NetworkError>) -> Void) {
        if shoudReturnError {
            completion(.failure(.decodingError))
        } else if let imageData = mockedImageData, !imageData.isEmpty {
            completion(.success(imageData))
        } else {
            completion(.failure(.noData))
        }
    }
    
    
}
