//
//  CalendarVC+Extensions.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/3/24.
//

import UIKit

// MARK: - Calendar
extension CalendarVC: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        let categoryListVC = CategoryListVC(with: dateToString(dateComponents))
        navigationController?.pushViewController(categoryListVC, animated: false)
    }
    
    internal func dateToString(_ dateComponents: DateComponents?) -> String {
        guard let dateComponents = dateComponents,
              let year = dateComponents.year,
              let month = dateComponents.month,
              let day = dateComponents.day else { return "no date" }
        return String(format: "%04d-%02d-%02d", year, month, day)
    }
}
