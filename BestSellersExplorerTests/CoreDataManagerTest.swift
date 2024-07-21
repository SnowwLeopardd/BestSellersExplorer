//
//  MockCoreDataManager.swift
//  BestSellers ExplorerTests
//
//  Created by Aleksandr Bochkarev on 6/27/24.
//

import XCTest
@testable import BestSellersExplorer

class CoreDataManagerTest: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    var coreDataStack: MockCoreDataStack!
    var testBook: Book!
    
    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataManager(mainContext: coreDataStack!.mainContext)
        testBook = Book(rank: 0,
                        primaryIsbn13: "000000",
                        description: "Test description",
                        title: "Test title",
                        author: "Test author",
                        bookImage: "Test urlImage"
        )
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        coreDataManager = nil
        testBook = nil
    }
    
    func testCreateSuccess() {
        coreDataManager.createFavoriteBook(from: testBook)
        
        var favoriteBooks: [FavoriteBook] = []
        var receivedError: Error?

        coreDataManager.fetchData { result in
            switch result {
            case .success(let data):
                favoriteBooks = data
            case .failure(let error):
                receivedError = error
            }
        }

        XCTAssertNil(receivedError)
        XCTAssertEqual(favoriteBooks.count, 1)
        
        let savedFavoriteBook = favoriteBooks.first!
        XCTAssertEqual(savedFavoriteBook.rank, Int32(testBook.rank))
        XCTAssertEqual(savedFavoriteBook.title, testBook.title)
        XCTAssertEqual(savedFavoriteBook.author, testBook.author)
        XCTAssertEqual(savedFavoriteBook.about, testBook.description)
        XCTAssertEqual(savedFavoriteBook.primaryIsbn13, testBook.primaryIsbn13)
        XCTAssertEqual(savedFavoriteBook.imageUrl, testBook.bookImage)
    }
    
    func testFetchDataSuccess() {
        let favoriteBook1 = FavoriteBook(context: coreDataStack.mainContext)
        favoriteBook1.rank = 1
        favoriteBook1.title = "Title 1"
        favoriteBook1.author = "Author 1"
        favoriteBook1.about = "Description 1"
        favoriteBook1.primaryIsbn13 = "ISBN1"
        favoriteBook1.imageUrl = "URL1"
        
        let favoriteBook2 = FavoriteBook(context: coreDataStack.mainContext)
        favoriteBook2.rank = 2
        favoriteBook2.title = "Title 2"
        favoriteBook2.author = "Author 2"
        favoriteBook2.about = "Description 2"
        favoriteBook2.primaryIsbn13 = "ISBN2"
        favoriteBook2.imageUrl = "URL2"
        
        coreDataManager.saveContext()
        
        var fetchedFavoriteBooks: [FavoriteBook] = []
        var receivedError: Error?
        
        coreDataManager.fetchData { result in
            switch result {
            case .success(let data):
                fetchedFavoriteBooks = data
            case .failure(let error):
                receivedError = error
            }
        }
        
        XCTAssertNil(receivedError)
        XCTAssertEqual(fetchedFavoriteBooks.count, 2)
        
        let fetchedBook1 = fetchedFavoriteBooks.first { $0.primaryIsbn13 == "ISBN1" }!
        XCTAssertEqual(fetchedBook1.rank, favoriteBook1.rank)
        XCTAssertEqual(fetchedBook1.title, favoriteBook1.title)
        XCTAssertEqual(fetchedBook1.author, favoriteBook1.author)
        XCTAssertEqual(fetchedBook1.about, favoriteBook1.about)
        XCTAssertEqual(fetchedBook1.primaryIsbn13, favoriteBook1.primaryIsbn13)
        XCTAssertEqual(fetchedBook1.imageUrl, favoriteBook1.imageUrl)
        
        let fetchedBook2 = fetchedFavoriteBooks.first { $0.primaryIsbn13 == "ISBN2" }!
        XCTAssertEqual(fetchedBook2.rank, favoriteBook2.rank)
        XCTAssertEqual(fetchedBook2.title, favoriteBook2.title)
        XCTAssertEqual(fetchedBook2.author, favoriteBook2.author)
        XCTAssertEqual(fetchedBook2.about, favoriteBook2.about)
        XCTAssertEqual(fetchedBook2.primaryIsbn13, favoriteBook2.primaryIsbn13)
        XCTAssertEqual(fetchedBook2.imageUrl, favoriteBook2.imageUrl)
    }
    
    func testDeleteSuccess() {
        coreDataManager.createFavoriteBook(from: testBook)
        
        var favoriteBooks: [FavoriteBook] = []
        var receivedError: Error?
        
        coreDataManager.fetchData { result in
            switch result {
            case .success(let data):
                favoriteBooks = data
            case .failure(let error):
                receivedError = error
            }
        }
        
        XCTAssertNil(receivedError)
        XCTAssertEqual(favoriteBooks.count, 1)
        
        let favoriteBook = favoriteBooks.first!
        coreDataManager.delete(favoriteBook)
        
        coreDataManager.fetchData { result in
            switch result {
            case .success(let data):
                favoriteBooks = data
            case .failure(let error):
                receivedError = error
            }
        }
        
        XCTAssertNil(receivedError)
        XCTAssertEqual(favoriteBooks.count, 0)
    }
    
    func testIsUniqueSuccess() {
        coreDataManager.isUnique(testBook.primaryIsbn13) { result in
            switch result {
            case .success(let data):
                XCTAssertTrue(data)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testIsUniqueFailure() {
        coreDataManager.createFavoriteBook(from: testBook)
        coreDataManager.createFavoriteBook(from: testBook)
        
        coreDataManager.isUnique(testBook.primaryIsbn13) { result in
            switch result {
            case .success(let data):
                XCTAssertFalse(data)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
}
