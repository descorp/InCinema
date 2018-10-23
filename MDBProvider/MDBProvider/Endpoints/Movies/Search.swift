//
//  Search.swift
//  MDBProvider
//
//  Created by Vladimir Abramichev on 20/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

public extension Endpoint where T == Response<Movie> {
    static func searchMovie(query: String, year: Int? = nil, page: Int? = nil,
                            region: String? = nil, language: String? = nil) -> Endpoint {
        var queries = [URLQueryItem(name: "query", value: query),]        
        if let year = year { queries.append(URLQueryItem(name: "year", value: "\(year)")) }
        if let page = page { queries.append(URLQueryItem(name: "page", value: "\(page)")) }
        if let region = region { queries.append(URLQueryItem(name: "region", value: region)) }
        if let language = language { queries.append(URLQueryItem(name: "language", value: language)) }
        
        return Endpoint(
            path: "/search/movie",
            queryItems: queries,
            parse: T.decode
        )
    }
}
