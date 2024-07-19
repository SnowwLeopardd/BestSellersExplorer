//
//  NetworkManagerTest.swift
//  BestSellers ExplorerTests
//
//  Created by Aleksandr Bochkarev on 6/25/24.
//

import XCTest
@testable import BestSellers_Explorer

class NetworkManagerTest: XCTestCase {
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
    }

    override func tearDown() {
        mockNetworkManager = nil
        super.tearDown()
    }
    
    // MARK: - FetchImage
    func testFetchImageSuccess() {
        let expectedData = createImageData()
        mockNetworkManager.mockedImageData = expectedData
        
        var receivedData: Data?
        var receivedError: NetworkError?
        
        mockNetworkManager.fetchImage(from: "Test") { result in
            switch result {
            case .success(let data):
                receivedData = data
            case .failure(let error):
                receivedError = error
            }
        }
        
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedData, expectedData, "The actual result \(String(describing: receivedData)) differs from the expected one \(String(describing: expectedData))")
    }
    
    func testFetchImageFailureNoData() {
        var receivedData: Data?
        var receivedError: NetworkError?
        
        mockNetworkManager.fetchImage(from: "Test") { result in
            switch result {
            case .success(let data):
                receivedData = data
            case .failure(let error):
                receivedError = error
            }
        }
        
        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.noData, "The error received \(String(describing: receivedError)) is different from the NetworkError.noDate")
        XCTAssertNil(receivedData)
    }
    
    func testFetchImageDecodingError() {
        mockNetworkManager.shoudReturnError = true
        var receivedData: Data?
        var receivedError: NetworkError?
        
        mockNetworkManager.fetchImage(from: "Test") { result in
            switch result {
            case .success(let data):
                receivedData = data
            case .failure(let error):
                receivedError = error
            }
        }
        
        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.decodingError, "The error received \(String(describing: receivedError)) is different from the NetworkError.decodingError")
        XCTAssertNil(receivedData)
    }
    
    // MARK: - FetchCategoryList
    func testFetchCategoryListSuccess() {
        let expectedData: CategotyList? = loadJson(fromResource: "CategoryListResponse")
        mockNetworkManager.genericType = expectedData
        
        var receivedData: CategotyList?
        var receivedError: NetworkError?
        
        mockNetworkManager.fetch(CategotyList.self, from: "Test") { result in
            switch result {
            case .success(let data):
                receivedData = data
            case .failure(let error):
                receivedError = error
            }
        }
        
        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.noData, "The error received \(String(describing: receivedError)) is different from the NetworkError.noDate")
        XCTAssertNil(receivedData)
    }
    
    func testFetchCategoryDecodingError() {
        mockNetworkManager.shoudReturnError = true
        var receivedData: CategotyList?
        var receivedError: NetworkError?
        
        mockNetworkManager.fetch(CategotyList.self, from: "Test") { result in
            switch result {
            case .success(let data):
                receivedData = data
            case .failure(let error):
                receivedError = error
            }
        }
        
        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.decodingError, "The error received \(String(describing: receivedError)) is different from the NetworkError.decodingError")
        XCTAssertNil(receivedData)
    }
    
    // MARK: - FetchTopBooksList
    func testFetchTopBooksListSuccess() {
        let expectedData: CategotyList? = loadJson(fromResource: "TopBooksListResponse")
        mockNetworkManager.genericType = expectedData
        
        var receivedData: TopBooksList?
        var receivedError: NetworkError?
        
        mockNetworkManager.fetch(TopBooksList.self, from: "Test") { result in
            switch result {
            case .success(let data):
                receivedData = data
            case .failure(let error):
                receivedError = error
            }
        }
        
        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.noData, "The error received \(String(describing: receivedError)) is different from the NetworkError.noDate")
        XCTAssertNil(receivedData)
    }
    
    func testTopBooksListDecodingError() {
        mockNetworkManager.shoudReturnError = true
        var receivedData: TopBooksList?
        var receivedError: NetworkError?
        
        mockNetworkManager.fetch(TopBooksList.self, from: "Test") { result in
            switch result {
            case .success(let data):
                receivedData = data
            case .failure(let error):
                receivedError = error
            }
        }
        
        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.decodingError, "The error received \(String(describing: receivedError)) is different from the NetworkError.decodingError")
        XCTAssertNil(receivedData)
    }
    
    // MARK: - QuotaLimit
    func testQuotaLimitSuccess() {
        mockNetworkManager.quotaLimitError = true
        var receivedData: TopBooksList?
        var receivedError: NetworkError?
        
        mockNetworkManager.fetch(TopBooksList.self, from: "Test") { result in
            switch result {
            case .success(let data):
                receivedData = data
            case .failure(let error):
                receivedError = error
            }
        }
        
        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.quotaLimitExceeded, "The error received \(String(describing: receivedError)) is different from the NetworkError.quotaLimitExceeded")
        XCTAssertNil(receivedData)
    }
    
    // MARK: - Functions
    func loadJson<T: Decodable>(fromResource resource: String) -> T? {
        guard let url = Bundle(for: type(of: self)).url(forResource: resource, withExtension: "json"),
              let jsonData = try? Data(contentsOf: url) else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let items = try decoder.decode(T.self, from: jsonData)
            return items
        } catch {
            print("Error decoding the JSON: \(error)")
            return nil
        }
    }
    
    func createImageData() -> Data? {
        guard let image = UIImage(named: "NYTimes Logo 1") else {
            return nil
        }
        guard let imageData = image.pngData() else {
            return nil
        }
        return imageData
    }
}
