//
//  MDBProviderTests.swift
//  MDBProviderTests
//
//  Created by Vladimir Abramichev on 20/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import XCTest
@testable import MDBProvider

class MDBProviderTests: XCTestCase {
    
    private let apiKey = "API_KEY"
    private let movieId = 297761
    private let imagePath = "/kqjL17yufvn9OVLyXYpvtyrFfak.jpg"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNowPlayingSuccessfull() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let sut = MDBProvider(apiKey: apiKey)
        let successExpectation = expectation(description: "Success")
        
        sut.request(Endpoint.nowPlaying()) { (result) in
            switch result {
            case let .success(responce):
                XCTAssertNotNil(responce)
                XCTAssertNotNil(responce.results)
                XCTAssertTrue(responce.results.count > 0)
                successExpectation.fulfill()
            case let .failure(error):
                print(error)
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchSuccessfull() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let sut = MDBProvider(apiKey: apiKey)
        let successExpectation = expectation(description: "Success")
        
        sut.request(Endpoint.searchMovie(query: "Solaris")) { (result) in
            switch result {
            case let .success(responce):
                XCTAssertNotNil(responce)
                XCTAssertNotNil(responce.results)
                XCTAssertTrue(responce.results.count > 0)
                successExpectation.fulfill()
            case let .failure(error):
                print(error)
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetMoviewSuccessfull() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let sut = MDBProvider(apiKey: apiKey)
        let successExpectation = expectation(description: "Success")
        
        sut.request(Endpoint.getMovie(id: movieId)) { (result) in
            switch result {
            case let .success(responce):
                XCTAssertNotNil(responce)
                XCTAssertEqual(responce.id, self.movieId)
                successExpectation.fulfill()
            case let .failure(error):
                print(error)
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadImageSuccessfull() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let sut = MDBProvider(apiKey: apiKey)
        let successExpectation = expectation(description: "Success")
        
        sut.request(Endpoint.loadImage(path: imagePath)) { (result) in
            switch result {
            case let .success(responce):
                XCTAssertNotNil(responce)
                XCTAssertTrue(responce.size.width > 0)
                XCTAssertTrue(responce.size.height > 0)
                successExpectation.fulfill()
            case let .failure(error):
                print(error)
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadImageDataSuccessfull() {
        let sut = MDBProvider(apiKey: apiKey)
        let successExpectation = expectation(description: "Success")
        sut.request(Endpoint.loadImageData(path: imagePath)) { (result) in
            switch result {
            case let .success(responce):
                XCTAssertNotNil(responce)
                XCTAssertTrue(responce.count > 0)
                successExpectation.fulfill()
            case let .failure(error):
                print(error)
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
