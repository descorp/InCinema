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
    var title: String { get }
    var originalTitle: String? { get }
    var plotDescription: String { get }
    var year: String { get }
    var rate: String { get }
    
    func loadImage()
}

class InCinemaMovieViewModel: MovieViewModel {
    
    weak var viewDelegate: ViewDelegate?
    
    private var model: MovieModel
    private var image: UIImage?
    
    init(model: MovieModel) {
        self.model = model
    }
    
    // MARK: Movie ViewModel
    
    var backdropImage: UIImage? {
        return image
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
    
    func loadImage() {
        model.loadImage { [weak self] (image, error) in
            guard
                let strongSelf = self,
                let image = image
            else { return }
            
            strongSelf.image = image
            strongSelf.viewDelegate?.itemsDidChange()
        }
    }
}
