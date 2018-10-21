//
//  DataLoader.swift
//  MDBProvider
//
//  Created by Vladimir Abramichev on 21/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public enum MDBProviderError: Error {
    case invalidURL
    case network(Error?)
    case parsingError
}

final internal class MDBProvider {
    private let config: EnvironmentConfiguration
    private static let sessionSecurity = SecureURLSession()
    private let urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                            delegate: sessionSecurity,
                                            delegateQueue: nil)
    
    public init(apiKey: String, bundle: Bundle = Bundle.main) {
        self.config = EnvironmentConfiguration()
        self.config.appKey = apiKey
    }
    
    func request<T>(_ endpoint: Endpoint<T>, then handler: @escaping (Result<T>) -> Void) {
        guard let url = endpoint.buildUrl(for: config) else {
            return handler(.failure(MDBProviderError.invalidURL))
        }
        
        let task = urlSession.dataTask(with: url) { data, _, error in
            if let data = data,
                let result = try? endpoint.parse(data) {
                handler(.success(result))
            }
            handler(.failure(MDBProviderError.network(error)))
            return
        }
        
        task.resume()
    }
}
