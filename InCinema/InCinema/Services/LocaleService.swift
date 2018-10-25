//
//  LocaleService.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 25/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

protocol HasLocale {
    var currentLocale: String { get }
}

class LocaleService: HasLocale {
    var currentLocale: String {
        return Locale.current.languageCode ?? "en"
    }
}
