//
//  EndpointUrlBuilderTest.swift
//  MDBProviderTests
//
//  Created by Vladimir Abramichev on 25/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import XCTest
@testable import MDBProvider

class EndpointUrlBuilderTests: XCTestCase {
    
    let config = EnvironmentConfiguration(dictionary: [
        "AppKey": "MY_KEY",
        "ImageApi": [
            "Url": "image.testing.api.com",
            "Version": 5 ],
        "BaseApi":  ["Url": "data.testing.api.com"]
        ])
    
    func testGetMovieSimpleEndpoint() {
        let endpoint = Endpoint.getMovie(id: 42, language: "RU")
        let sut = endpoint.buildUrl(for: config)
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.absoluteString, "https://data.testing.api.com/movie/42?language=RU&api_key=MY_KEY")
    }
    
    func testSerchMovieFullEndpoint() {
        let endpoint = Endpoint.searchMovie(query: "SEARCH", year: 2017, page: 2, region: "RU", language: "RU")
        let sut = endpoint.buildUrl(for: config)
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.absoluteString, "https://data.testing.api.com/search/movie?query=SEARCH&year=2017&page=2&region=RU&language=RU&api_key=MY_KEY")
    }
    
    func testGetNowShowingFullEndpoint() {
        let endpoint = Endpoint.nowPlaying(page: 2, region: "RU", language: "ru")
        let sut = endpoint.buildUrl(for: config)
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.absoluteString, "https://data.testing.api.com/movie/now_playing?page=2&region=RU&language=ru&api_key=MY_KEY")
    }
    
    func testImageEndpoint() {
        let endpoint = Endpoint.loadImage(path: "/kqjL17yufvn9OVLyXYpvtyrFfak.jpg", size: .w500)
        let sut = endpoint.buildUrl(for: config)
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.absoluteString, "https://image.testing.api.com/5/t/p/w500/kqjL17yufvn9OVLyXYpvtyrFfak.jpg?api_key=MY_KEY")
    }
    
    func testUpcomingEndpoint() {
        let endpoint = Endpoint.upcoming(page: 2, region: "RU", language: "ru")
        let sut = endpoint.buildUrl(for: config)
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.absoluteString, "https://data.testing.api.com/movie/upcoming?page=2&region=RU&language=ru&api_key=MY_KEY")
    }
}
