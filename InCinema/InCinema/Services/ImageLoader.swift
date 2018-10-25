//
//  ImageLoader.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 25/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

protocol HasImageLoader {
    func load(path: String, than handler: @escaping (UIImage?, Error?) -> Void)
}

enum ImageLoaderError: Error {
    case emptyPath
}

class ImageLoader: HasImageLoader {
    
    private let cache: NSCache<NSString, UIImage>
    
    init() {
        self.cache = NSCache<NSString, UIImage>()
        self.cache.countLimit = 100
    }
    
    func load(path: String, than handler: @escaping (UIImage?, Error?) -> Void) {
        if let image = cache.object(forKey: path as NSString) {
            handler(image, nil)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard
                let url = URL(string: path),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data)
            else {
                handler(nil, ImageLoaderError.emptyPath)
                return
            }
            
            self?.cache.setObject(image, forKey: path as NSString, cost: data.count)
            handler(image, nil)
        }
    }
}
