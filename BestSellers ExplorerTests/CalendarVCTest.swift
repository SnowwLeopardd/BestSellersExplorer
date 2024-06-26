//
//  CalendarVC+EntensionTest.swift
//  BestSellers ExplorerTests
//
//  Created by Aleksandr Bochkarev on 6/14/24.
//

import XCTest
@testable import BestSellers_Explorer

final class CalendarVCTest: XCTestCase {

    func testSucessfulDateConvertion() {
        // Given (Arrange)
        let calendarVC = CalendarVC()
        let date = DateComponents(year: 2024, month: 06, day: 14)
        
        // When (Act)
        let convertedDate = calendarVC.dateToString(date)
        
        //Then (Assert)
        XCTAssertEqual(convertedDate, "2024-06-14")
    }
}
