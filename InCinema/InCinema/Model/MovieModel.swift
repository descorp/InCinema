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
    func loadImage(_ type: ImageType, than handler: @escaping (UIImage?, Error?) -> Void)
}

enum ImageType {
    case poster
    case backdrop
}

enum MovieImageError: Error {
    case imageNotAvailable
}

class InCinemaMovieModel: MovieModel {
    typealias Dependency = HasMDB & HasLocale & HasImageService
    
    private let dependency: Dependency
    
    var movie: Movie
    
    init(movie: Movie, dependency: Dependency) {
        self.dependency = dependency
        self.movie = movie
    }
    
    func loadDetails(than handler: @escaping (MovieDetails?, Error?) -> Void) {
        let locale = self.dependency.currentLocale
        self.dependency.moviesService.getMovie(id: movie.id, language: locale, than: handler)
    }
    
    func loadImage(_ type: ImageType, than handler: @escaping (UIImage?, Error?) -> Void) {
        let path: String?
        switch type {
        case .poster:
            path = movie.posterPath
        case .backdrop:
            path = movie.backdropPath
        }
        
        guard
            let moviePath = path
        else {
            handler(nil, MovieImageError.imageNotAvailable)
            return
        }
        
        self.dependency.load(path: moviePath, than: handler)
    }
}
