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
    
    var viewDelegate: ViewDelegate? { get set }
    
    var backdropImage: UIImage? { get }
    var posterImage: UIImage? { get }
    var movieTitle: String { get }
    var originalTitle: String? { get }
    var plotDescription: String { get }
    var year: String { get }
    var rate: String { get }
    
    func loadImage(_ type: ImageType)
    
    var posterNotAvailable: Bool? { get }
    var backdropNotAvailable: Bool? { get }
}

class InCinemaMovieViewModel: MovieViewModel {
    
    private var model: MovieModel
    
    weak var viewDelegate: ViewDelegate?
    
    var title: String {
        return String.localize(key: "details_title")
    }
    
    init(model: MovieModel) {
        self.model = model
    }
    
    // MARK: Movie ViewModel
    
    var posterNotAvailable: Bool?
    
    var backdropNotAvailable: Bool?
    
    var backdropImage: UIImage?
    
    var posterImage: UIImage?
    
    private var movie: Movie {
        return model.movie
    }
    
    var movieTitle: String {
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
    
    func loadImage(_ type: ImageType) {
        model.loadImage(type) { [weak self] (image, error) in
            guard
                let strongSelf = self
            else { return }
            
            switch type {
            case .poster:
                strongSelf.posterImage = image
                strongSelf.posterNotAvailable = image == nil
                break
            case .backdrop:
                strongSelf.backdropImage = image
                strongSelf.backdropNotAvailable = image == nil
                break
            }
            
            strongSelf.viewDelegate?.itemsDidChange()
        }
    }
}
