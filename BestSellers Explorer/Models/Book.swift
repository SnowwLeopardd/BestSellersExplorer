//
//  Book.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 5/31/24.
//

struct Book: Decodable {
    let rank: Int
    let primaryIsbn13: String
    let description: String
    let title: String
    let author: String
    let bookImage: String
    let bookImageWidth: Int
    let bookImageHeight: Int
}
