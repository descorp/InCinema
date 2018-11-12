//
//  MovieCollectionModel.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 24/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import MDBProvider

protocol MovieCollectionModel {
    func load(page: Int, region: String, than handler: @escaping (([Movie], Int)?, Error?) -> Void)
    func search(query: String, page: Int, than handler: @escaping (([Movie], Int)?, Error?) -> Void)
}

class InCinemaMovieCollectionModel: MovieCollectionModel {
    typealias Dependency = HasMDB & HasLocale
    
    let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func load(page: Int, region: String, than handler: @escaping (([Movie], Int)?, Error?) -> Void) {
        let locale = self.dependency.currentLocale
        self.dependency.moviesService.getMoviesInCinema(region: region, page: page, language: locale, than: handler)
    }
    
    func search(query: String, page: Int = 1, than handler: @escaping (([Movie], Int)?, Error?) -> Void) {
        let locale = self.dependency.currentLocale
        self.dependency.moviesService.search(query: query, language: locale, than: handler)
    }
}
