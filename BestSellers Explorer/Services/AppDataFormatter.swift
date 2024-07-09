//
//  AppDataFormatter.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 7/9/24.
//

import Foundation

class AppDateFormatter {
    static let shared = AppDateFormatter()
    
    private let dateFormatter: DateFormatter
    
    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func date(from string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
}
