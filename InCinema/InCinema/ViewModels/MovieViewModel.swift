//
//  MoviewDetailsViewModel.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 24/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import MDBProvider

protocol MovieViewModel: ViewModel {
    var backdropImage: UIImage? { get }
    var title: String { get }
    var originalTitle: String? { get }
    var plotDescription: String { get }
    var year: String { get }
    var rate: String { get }
}

class InCinemaMovieViewModel: MovieViewModel {
    
    private var viewDelegate: ViewDelegate?
    private var coordinatorDelegate: CoordinatorDelegate?
    private var model: MovieModel
    
    init(model: MovieModel,
         viewDelegate: ViewDelegate? = nil,
         coordinatorDelegate: CoordinatorDelegate? = nil) {
        self.model = model
        self.viewDelegate = viewDelegate
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    var backdropImage: UIImage? {
        return nil
    }
    
    private var movie: Movie {
        return model.movie
    }
    
    var title: String {
        return movie.title
    }
    
    var originalTitle: String? {
        return movie.title != movie.originalLanguage ? movie.originalLanguage : nil
    }
    
    var plotDescription: String {
        return movie.overview
    }
    
    var year: String {
        return movie.releaseDate.components(separatedBy: "-").first ?? ""
    }
    
    var rate: String {
        return "\(movie.voteAverage) / \(movie.voteCount)"
    }
}
