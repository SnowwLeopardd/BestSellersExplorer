//
//  BookReview.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 4/5/24.
//

struct BookReview: Decodable {
    let results: [BookDescription]
}

struct BookDescription: Decodable {
    let url: String
    let publicationDt: String
    let byline: String
    let bookTitle: String
    let bookAuthor: String
    let summary: String
    let isbn13: String
}
