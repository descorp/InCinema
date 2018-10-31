//
//  Parsable.swift
//  MDBProvider
//
//  Created by Vladimir Abramichev on 23/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

extension Encodable {
    func encoded() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

extension Decodable {
    static func decode<T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
