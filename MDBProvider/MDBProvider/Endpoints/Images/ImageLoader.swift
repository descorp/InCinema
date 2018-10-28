//
//  ImageLoader.swift
//  MDBProvider
//
//  Created by Vladimir Abramichev on 25/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

public enum ImageSize: String {
    case w92 = "w92"
    case w154 = "w154"
    case w185 = "w185"
    case w342 = "w342"
    case w500 = "w500"
    case w780 = "w780"
    case original = "original"
}


public extension Endpoint where T == UIImage {
    static func loadImage(path: String, size: ImageSize = .original) -> Endpoint {
        let finalPath = path.hasPrefix("/") ? "\(path.dropFirst())" : path
        return Endpoint(
            host: .image,
            path: "/t/p/\(size)/\(finalPath)",
            queryItems: [],
            parse: UIImage.convert
        )
    }
}

public extension Endpoint where T == Data {
    static func loadImageData(path: String, size: ImageSize = .original) -> Endpoint {
        let finalPath = path.hasPrefix("/") ? "\(path.dropFirst())" : path
        return Endpoint(
            host: .image,
            path: "/t/p/\(size)/\(finalPath)",
            queryItems: [],
            parse: { $0 }
        )
    }
}

extension UIImage {
    static func convert(data: Data) throws -> UIImage {
        guard
            let image = UIImage(data: data)
        else { throw MDBProviderError.invalidImage }
        return image
    }
}
