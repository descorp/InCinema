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
    func viewModelDidSelectMovie(_ viewModel: ViewModel, item: MovieViewModel)
}

protocol MovieCollectionViewModel: ViewModel {
    
    var collection: [MovieViewModel] { get }
    var scrollPosition: Float { get }
    
    func loadMore()
    func search(query: String)
    func stopSearch()
    func updateScrollPosition(_ position: Float)
    func selectMovie(item: MovieViewModel)
}

class InCinemaMovieCollectionViewModel: MovieCollectionViewModel {
    typealias Dependency = HasLocation & HasMDB & HasImageService & HasLocale
    
    private let dependency: Dependency
    private var model: MovieCollectionModel
    private var collectionCache = [Movie]()
    private var page = 1
    private var lastUpdate = Date(timeIntervalSince1970: 0)
    private var updateTrashhold = 2
    private var isOnSearch = false
    
    weak var viewDelegate: ViewDelegate?
    weak var coordinatorDelegate: MovieCollectionViewModelCoordinatorDelegate?
    
    init(model: MovieCollectionModel,
         dependency: Dependency) {
        self.model = model
        self.dependency = dependency
    }
    
    // MARK: MovieCollection ViewModel
    
    var collection = [MovieViewModel]()
    var scrollPosition: Float = 0.0
    
    func loadMore() {
        guard
            lastUpdate < Date(timeIntervalSinceNow: TimeInterval(-updateTrashhold)) && !isOnSearch
        else { return }
        
        self.lastUpdate = Date()
        let region = dependency.currentLocation
        self.model.load(page: page, region: region) { [weak self] (data, error) in
            guard
                let strongSelf = self
            else { return }
            
            if let data = data {
                strongSelf.page += 1
                strongSelf.collectionCache = strongSelf.collectionCache + data
                strongSelf.collection = strongSelf.collectionCache.map(strongSelf.toViewModel)
                strongSelf.viewDelegate?.itemsDidChange()
                return
            }
            
            strongSelf.coordinatorDelegate?.viewModelDidThrowError(strongSelf, error: error)
        }
    }
    
    func search(query: String) {
        isOnSearch = true
        self.model.search(query: query) { [weak self]  (data, error) in
            guard
                let strongSelf = self
            else { return }
            
            if let data = data {
                strongSelf.page = 1
                strongSelf.collection = data.map(strongSelf.toViewModel)
                strongSelf.viewDelegate?.itemsDidChange()
                return
            }
            
            strongSelf.coordinatorDelegate?.viewModelDidThrowError(strongSelf, error: error)
        }
    }
    
    func stopSearch() {
        isOnSearch = false
        self.collection = self.collectionCache.map(toViewModel)
        self.viewDelegate?.itemsDidChange()
    }
    
    func updateScrollPosition(_ position: Float) {
        self.scrollPosition = position
    }
    
    func selectMovie(item: MovieViewModel) {
        self.coordinatorDelegate?.viewModelDidSelectMovie(self, item: item)
    }
    
    func toViewModel(movie: Movie) -> MovieViewModel {
        let movieModel = InCinemaMovieModel(movie: movie, dependency: self.dependency)
        return InCinemaMovieViewModel(model: movieModel)
    }
}
