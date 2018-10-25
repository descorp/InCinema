//
//  GetMovie.swift
//  MDBProvider
//
//  Created by Vladimir Abramichev on 23/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

public extension Endpoint where T == MovieDetails {
    static func getMovie(id: Int, language: String? = nil) -> Endpoint {
        var queries = [URLQueryItem]()
        if let language = language { queries.append(URLQueryItem(name: "language", value: language)) }
        
        return Endpoint(
            host: .data,
            path: "/movie/\(id)",
            queryItems: queries,
            parse: T.decode
        )
    }
}
