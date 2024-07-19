//
//  MockNetworkManager.swift
//  BestSellers ExplorerTests
//
//  Created by Aleksandr Bochkarev on 6/25/24.
//

import XCTest
@testable import BestSellers_Explorer

class MockNetworkManager: NetworkManagerProtocol {
    init(shoudReturnError: Bool = false, quotaLimitError: Bool = false, mockedImageData: Data? = nil, genericType: Any? = nil) {
        self.shoudReturnError = shoudReturnError
        self.quotaLimitError = quotaLimitError
        self.mockedImageData = mockedImageData
        self.genericType = genericType
    }
    
    
    let shoudReturnError: Bool
    let quotaLimitError: Bool
    let mockedImageData: Data?
    let genericType: Any?
    
    func fetch<T>(_ type: T.Type, from url: String?, completion: @escaping (Result<T, BestSellers_Explorer.NetworkError>) -> Void) where T : Decodable {
        if shoudReturnError {
            completion(.failure(.decodingError))
        } else if quotaLimitError {
            completion(.failure(.quotaLimitExceeded))
        } else if let data = genericType as? T {
            if let collection = data as? (any Collection), collection.isEmpty {
                completion(.failure(.noData))
            } else {
                completion(.success(data))
            }
        } else {
            completion(.failure(.noData))
        }
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
