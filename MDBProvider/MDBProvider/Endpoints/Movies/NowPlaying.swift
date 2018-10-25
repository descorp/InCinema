//
//  Movies.swift
//  MDBProvider
//
//  Created by Vladimir Abramichev on 20/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

public extension Endpoint where T == Response<Movie>  {
    static func nowPlaying(page pageNumber: Int? = nil, region regCode: String? = nil, language langCode: String? = nil) -> Endpoint {
        var queries = [URLQueryItem]()
        if let page = pageNumber { queries.append(URLQueryItem(name: "page", value: "\(page)")) }
        if let region = regCode { queries.append(URLQueryItem(name: "region", value: region)) }
        if let language = langCode { queries.append(URLQueryItem(name: "language", value: language)) }
        
        return Endpoint(
            host: .data,
            path: "/movie/now_playing",
            queryItems: queries,
            parse: T.decode
        )
    }
}
