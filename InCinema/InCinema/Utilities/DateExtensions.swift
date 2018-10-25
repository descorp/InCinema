//
//  DateExtensions.swift
//  CoinDeskApp
//
//  Created by Vladimir Abramichev on 29/07/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

extension Date {
    
    func formar(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter.string(from: self)
    }
    
    init?(format: String, value: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = formatter.date(from: value) {
            self = date
        } else {
            return nil
        }
    }
}
