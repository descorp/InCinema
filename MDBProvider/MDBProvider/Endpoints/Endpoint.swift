//
//  Endpoint.swift
//  MDBProvider
//
//  Created by Vladimir Abramichev on 20/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

enum BaseUrlType {
    case image
    case data
}

public struct Endpoint<T> {
    let host: BaseUrlType
    let path: String
    let queryItems: [URLQueryItem]
    let parse: (Data) throws -> T
}

extension Endpoint {
    func buildUrl(for config: EnvironmentConfiguration) -> URL? {
        let apiConfig = config.apiUrl(host)
        var components = URLComponents()
        components.scheme = "https"
        components.host = apiConfig.url
        components.appendPath(apiConfig.version)
        components.appendPath(path)
        var mutableQueryArray = queryItems
        mutableQueryArray.append(URLQueryItem(name: "api_key", value: config.appKey))
        components.queryItems = mutableQueryArray
        
        return components.url
    }
}

extension URLComponents {
    mutating func appendPath(_ component: String?) {
        guard let component = component else { return }
        appendPath(component.hasPrefix("/") ? "\(component.dropFirst())" : component)
    }
    
    mutating func appendPath(_ component: Int?) {
        guard let component = component else { return }
        appendPath("\(component)")
    }
    
    private mutating func appendPath(_ component: String) {
        self.path += String.init(stringInterpolation: "/", component)
    }
}
