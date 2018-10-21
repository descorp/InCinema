//
//  ResponseWrapper.swift
//  MDBProvider
//
//  Created by Vladimir Abramichev on 21/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

public struct Response<T: Codable>: Codable {
    let page: Int
    let results: [T]
    let totalResults, totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

extension Response {
    static func parse(data: Data) throws -> Response {
        return try JSONDecoder().decode(self, from: data)
    }
}
