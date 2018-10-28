//
//  ImageLoader.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 25/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

protocol HasImageService {
    func load(path: String, than handler: @escaping (UIImage?, Error?) -> Void)
}

enum ImageLoaderError: Error {
    case emptyPath
}

class ImageService: HasImageService {
    
    private let imageLoader: HasImageLoader
    private let cache: NSCache<NSString, UIImage>
    
    init(imageLoader: HasImageLoader) {
        self.cache = NSCache<NSString, UIImage>()
        self.cache.countLimit = 100
        self.imageLoader = imageLoader
    }
    
    func load(path: String, than handler: @escaping (UIImage?, Error?) -> Void) {
        if let image = cache.object(forKey: path as NSString) {
            handler(image, nil)
            return
        }
        
        self.imageLoader.loadImage(path: path) { [weak self] (data, error) in
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                handler(nil, error)
                return
            }
            
            self?.cache.setObject(image, forKey: path as NSString, cost: data.count)
            handler(image, nil)
        }
    }
}
