//
//  EnvironmentConfiguration.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 24/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

import Foundation

protocol HasConfig {
    var appKey: String { get }
}

internal final class EnvironmentConfiguration {
    
    static let current = EnvironmentConfiguration()
    
    var config: [AnyHashable : Any]
    
    init(dictionary: [AnyHashable : Any]) {
        config = dictionary
    }
    
    convenience init() {
        let bundle = Bundle.init(for: EnvironmentConfiguration.self)
        let configPath = bundle.path(forResource: "config", ofType: "plist")!
        let config = NSDictionary(contentsOfFile: configPath)!
        
        var dict = [AnyHashable : Any]()
        if let commonConfig = config["Common"] as? [AnyHashable: Any] {
            dict = commonConfig
        }
        
        self.init(dictionary: dict)
    }
}

extension EnvironmentConfiguration: HasConfig {
    var appKey: String {
        set { config["AppKey"] = newValue }
        get { return config["AppKey"] as! String }
    }
}
