//
//  File.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 5/31/24.
//

struct Results: Decodable {
    let listName: String
//    let bestsellersDate: String
//    let publishedDate: String
//    let displayName: String
//    let normalListEndsAt: Int
//    let updated: String
    let books: [Book]
}
