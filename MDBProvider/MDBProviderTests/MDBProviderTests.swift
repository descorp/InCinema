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
        let sut = MDBProvider(apiKey: apiKey)
        let successExpectation = expectation(description: "Success")
        
        sut.request(Endpoint.nowPlaying()) { (result) in
            if case .success(let responce) = result {
                XCTAssertNotNil(responce)
                XCTAssertNotNil(responce.results)
                XCTAssertTrue(responce.results.count > 0)
                successExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchSuccessfull() {
        let sut = MDBProvider(apiKey: apiKey)
        let successExpectation = expectation(description: "Success")
        
        sut.request(Endpoint.searchMovie(query: "Solaris")) { (result) in
            if case .success(let responce) = result {
                XCTAssertNotNil(responce)
                XCTAssertNotNil(responce.results)
                XCTAssertTrue(responce.results.count > 0)
                successExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetMoviewSuccessfull() {
        let sut = MDBProvider(apiKey: apiKey)
        let successExpectation = expectation(description: "Success")
        
        sut.request(Endpoint.getMovie(id: movieId)) { (result) in
            if case .success(let responce) = result {
                XCTAssertNotNil(responce)
                XCTAssertEqual(responce.id, self.movieId)
                successExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadImageSuccessfull() {
        let sut = MDBProvider(apiKey: apiKey)
        let successExpectation = expectation(description: "Success")
        
        sut.request(Endpoint.loadImage(path: imagePath)) { (result) in
            if case .success(let responce) = result {
                XCTAssertNotNil(responce)
                XCTAssertTrue(responce.size.width > 0)
                XCTAssertTrue(responce.size.height > 0)
                successExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadImageDataSuccessfull() {
        let sut = MDBProvider(apiKey: apiKey)
        let successExpectation = expectation(description: "Success")
        sut.request(Endpoint.loadImageData(path: imagePath)) { (result) in
            if case .success(let responce) = result {
                XCTAssertNotNil(responce)
                XCTAssertTrue(responce.count > 0)
                successExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testUpcomingSuccessfull() {
        let sut = MDBProvider(apiKey: apiKey)
        let successExpectation = expectation(description: "Success")
        sut.request(Endpoint.upcoming()) { (result) in
            if case .success(let responce) = result {
                XCTAssertNotNil(responce)
                XCTAssertTrue(responce.results.count > 0)
                successExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFailing() {
        let sut = MDBProvider(apiKey: "wrong_apiKey")
        let successExpectation = expectation(description: "Failure")
        sut.request(Endpoint.upcoming()) { (result) in
            if case .failure(_) = result {
                successExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
