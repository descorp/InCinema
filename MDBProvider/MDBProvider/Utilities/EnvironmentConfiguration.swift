//
//  MDBConfig.swift
//  MDBProvider
//
//  Created by Vladimir Abramichev on 21/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

internal struct ApiConfig {
    let url: String
    let version: Int?
}

internal final class EnvironmentConfiguration {
    
    static let current = EnvironmentConfiguration()
    
    var config: [String : Any]
    
    init(dictionary: [String : Any]) {
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
        
        self.init(dictionary: dict as! [String : Any])
    }
}

extension EnvironmentConfiguration {
    var appKey: String {
        set { config["AppKey"] = newValue }
        get { return config["AppKey"] as! String }
    }
    
    func apiUrl(_ baseUrlType: BaseUrlType) -> ApiConfig {
        var apiName: String
        switch baseUrlType {
        case .image:
            apiName = "ImageApi"
        case .data:
            apiName = "BaseApi"
        }
        
        guard
            let dictionary = config[apiName] as? NSDictionary
        else { preconditionFailure("Configuration file is invalid") }
        
        return ApiConfig(from: dictionary)
    }
}

extension ApiConfig {
    init(from dictionary: NSDictionary) {
        guard
            let url = dictionary["Url"] as? String
        else { preconditionFailure("Configuration file is invalid") }
        
        let version = dictionary["Version"] as? Int
        self = ApiConfig(url: url, version: version)
    }
}
