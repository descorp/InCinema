//
//  LocationService.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 23/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

protocol HasLocation {
    var locationService: ILocationService { get }
}

protocol ILocationService {
    var currentLocation: String { get }
}

class LocationService: ILocationService {
    var currentLocation: String {
        return Locale.current.regionCode ?? "US"
    }
}
