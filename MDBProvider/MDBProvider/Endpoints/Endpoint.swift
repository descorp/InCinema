//
//  Endpoint.swift
//  MDBProvider
//
//  Created by Vladimir Abramichev on 20/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

public struct Endpoint<T> {
    let path: String
    let queryItems: [URLQueryItem]
    let parse: (Data) throws -> T
}

extension Endpoint {
    func buildUrl(for config: EnvironmentConfiguration) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = config.baseApiUrl
        components.path = "/\(config.version)" + path
        components.queryItems = queryItems
        
        return components.url
    }
}
