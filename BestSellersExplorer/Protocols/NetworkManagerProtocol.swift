//
//  NetworkManagerProtocol.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/25/24.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetch<T:Decodable>(_ type: T.Type, from url: String?, completion: @escaping (Result<T, NetworkError>) -> Void)
    func fetchImage(from url: String?, completion: @escaping (Result<Data, NetworkError>) -> Void)
}
