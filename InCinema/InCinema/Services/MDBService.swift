//
//  MDBService.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 23/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import MDBProvider

protocol IMDBProvider {
    func getMoviesInCinema(region: String)
    func getMovie(regio)
}

protocol HasMDB {
    var mdbProvider: MDBProvider { get }
}

