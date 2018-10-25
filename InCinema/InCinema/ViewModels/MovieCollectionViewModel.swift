//
//  MovieCollectionViewModel.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 24/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import MDBProvider

protocol MovieCollectionViewModelCoordinatorDelegate: CoordinatorDelegate {
    func viewModelDidSelectMovie(_ viewModel: ViewModel, movie: Movie)
}

protocol MovieCollectionViewModel: ViewModel {
    
    var collection: [MovieViewModel] { get }
    var scrollPosition: Float { get }
    
    func loadMore()
    func search(query: String)
    func stopSearch()
    func updateScrollPosition(_ position: Float)
    func selectMovie(movie: Movie)
}

class InCinemaMovieCollectionViewModel: MovieCollectionViewModel {
    typealias Dependency = HasLocation & HasMDB & HasImageLoader & HasLocale
    
    private let dependency: Dependency
    private var model: MovieCollectionModel
    private var collectionCache: [Movie]
    private var page = 1
    
    var viewDelegate: ViewDelegate?
    var coordinatorDelegate: MovieCollectionViewModelCoordinatorDelegate?
    var collection = [MovieViewModel]()
    var scrollPosition: Float = 0.0
    
    init(model: MovieCollectionModel,
         dependency: Dependency,
         viewDelegate: ViewDelegate? = nil,
         coordinatorDelegate: MovieCollectionViewModelCoordinatorDelegate? = nil) {
        self.model = model
        self.dependency = dependency
        self.viewDelegate = viewDelegate
        self.coordinatorDelegate = coordinatorDelegate
        self.collectionCache = []
    }
    
    func loadMore() {
        let region = dependency.currentLocation
        self.model.load(page: page, region: region) { [weak self] (data, error) in
            guard
                let strongSelf = self
            else { return }
            
            if let data = data {
                strongSelf.page += 1
                strongSelf.collectionCache = strongSelf.collectionCache + data
                strongSelf.collection = strongSelf.collectionCache.map(strongSelf.toViewModel)
                strongSelf.viewDelegate?.itemsDidChange(viewModel: strongSelf)
                return
            }
            
            strongSelf.coordinatorDelegate?.viewModelDidThrowError(strongSelf, error: error)
        }
    }
    
    func search(query: String) {
        self.model.search(query: query) { [weak self]  (data, error) in
            guard
                let strongSelf = self
            else { return }
            
            if let data = data {
                strongSelf.page = 1
                strongSelf.collection = data.map(strongSelf.toViewModel)
                strongSelf.viewDelegate?.itemsDidChange(viewModel: strongSelf)
                return
            }
            
            strongSelf.coordinatorDelegate?.viewModelDidThrowError(strongSelf, error: error)
        }
    }
    
    func stopSearch() {
        self.collection = self.collectionCache.map(toViewModel)
        self.viewDelegate?.itemsDidChange(viewModel: self)
    }
    
    func updateScrollPosition(_ position: Float) {
        self.scrollPosition = position
    }
    
    func selectMovie(movie: Movie) {
        self.coordinatorDelegate?.viewModelDidSelectMovie(self, movie: movie)
    }
    
    func toViewModel(movie: Movie) -> MovieViewModel {
        let movieModel = InCinemaMovieModel(movie: movie, dependency: self.dependency)
        return InCinemaMovieViewModel(model: movieModel)
    }
}
