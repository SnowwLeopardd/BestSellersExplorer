//
//  CalendarVC+Extensions.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/3/24.
//

import UIKit

extension CalendarVC: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        choosenDate = dateToString(dateComponents)
        chooseCategoryButton.setTitle("Now, click here to choose category", for: .normal)
    }
    
    internal func dateToString(_ dateComponents: DateComponents?) -> String {
        guard let dateComponents = dateComponents,
              let year = dateComponents.year,
              let month = dateComponents.month,
              let day = dateComponents.day else { return "no date" }
        return String(format: "%04d-%02d-%02d", year, month, day)
    }
    
    func createDate(from date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: date)
    }
    
    func setupCalendarRange() {
        let startDate = createDate(from: "2019-01-01") ?? Date(timeIntervalSince1970: 0)
        let endDate = Date()
        let calendarViewDateRange = DateInterval(start: startDate, end: endDate)
        calendarView.availableDateRange = calendarViewDateRange
    }
}
