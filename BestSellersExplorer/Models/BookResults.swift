//
//  File.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 5/31/24.
//

struct BookResults: Decodable {
    let listName: String
    let books: [Book]
}
