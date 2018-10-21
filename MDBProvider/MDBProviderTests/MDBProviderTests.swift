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
    
    private let apiKey = "Your API key here"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let sut = MDBProvider(apiKey: apiKey)
        sut.request(Endpoint.nowPlaying()) { (result) in
            switch result {
            case let .success(responce):
                XCTAssertNotNil(responce)
                XCTAssertNotNil(responce.results)
                XCTAssertTrue(responce.results.count > 0)
            case let .failure(error):
                print(error)
                XCTFail()
            }
        }
    }
}
