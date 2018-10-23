//
//  ResponseWrapper.swift
//  MDBProvider
//
//  Created by Vladimir Abramichev on 21/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

public struct Response<T: Codable>: Codable {
    public let page: Int
    public let results: [T]
    public let totalResults, totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}
