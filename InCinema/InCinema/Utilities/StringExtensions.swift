//
//  StringExtensions.swift
//  CoinDeskApp
//
//  Created by Vladimir Abramichev on 29/07/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

extension String {
    
    static func localize(key: String, comment: String = "") -> String {
        return NSLocalizedString(key, comment: "")
    }
    
}
