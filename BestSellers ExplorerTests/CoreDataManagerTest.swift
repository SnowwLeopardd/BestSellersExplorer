//
//  MockCoreDataManager.swift
//  BestSellers ExplorerTests
//
//  Created by Aleksandr Bochkarev on 6/27/24.
//

import XCTest
@testable import BestSellers_Explorer

class CoreDataManagerTest: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    var coreDataStack: MockCoreDataStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataManager(mainContext: coreDataStack.mainContext)
    }
    
    func testCreateSuccess(_ book: BestSellers_Explorer.Book) {
        <#code#>
    }
    
    func testFetchDataSuccess(completion: (Result<[BestSellers_Explorer.FavoriteBook], any Error>) -> Void) {
        <#code#>
    }
    
    func testDeleteSuccess(_ favoriteBook: BestSellers_Explorer.FavoriteBook) {
        <#code#>
    }
    
    func testIsUniqueSuccess(_ primaryIsbn13: String) -> Bool {
        <#code#>
    }
    
    func testIsUniqueFaulire(_ primaryIsbn13: String) -> Bool {
        <#code#>
    }
}
