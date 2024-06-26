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
