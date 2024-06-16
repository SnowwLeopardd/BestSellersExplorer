//
//  Book.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 5/31/24.
//

struct Book: Decodable {
    let rank: Int
//    let rankLastWeek: Int
//    let weeksOnList: Int
//    let asterisk: Int
//    let dagger: Int
    let primaryIsbn10: String
    let primaryIsbn13: String
//    let publisher: String
    let description: String
//    let price: String
    let title: String
    let author: String
//    let contributor: String
//    let contributorNote: String
    let bookImage: String
    let amazonProductUrl: String
//    let ageGroup: String
//    let bookReviewLink: String
//    let firstChapterLink: String
//    let sundayReviewLink: String
//    let articleChapterLink: String
//    let isbns: [Isbn]
}
