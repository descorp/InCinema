//
//  MovieDetailsModel.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 24/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import MDBProvider

protocol MovieModel {
    var movie: Movie { get }
    func loadDetails(than handler: @escaping (MovieDetails?, Error?) -> Void)
    func loadImage(than handler: @escaping (UIImage?, Error?) -> Void)
}

class InCinemaMovieModel: MovieModel {
    typealias Dependency = HasMDB & HasLocale & HasImageLoader
    
    private let dependency: Dependency
    let movie: Movie
    
    init(movie: Movie, dependency: Dependency) {
        self.dependency = dependency
        self.movie = movie
    }
    
    func loadDetails(than handler: @escaping (MovieDetails?, Error?) -> Void) {
        let locale = self.dependency.currentLocale
        self.dependency.moviesService.getMovie(id: movie.id, language: locale, than: handler)
    }
    
    func loadImage(than handler: @escaping (UIImage?, Error?) -> Void) {
        guard
            let path = movie.backdropPath
        else {
            handler(nil, nil)
            return
        }
        
        self.dependency.load(path: path, than: handler)
    }
}
