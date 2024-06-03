//
//  BookDescription.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 5/31/24.
//

struct BookDescription: Decodable {
    let url: String
    let publicationDt: String
    let byline: String
    let bookTitle: String
    let bookAuthor: String
    let summary: String
    let isbn13: String
}
