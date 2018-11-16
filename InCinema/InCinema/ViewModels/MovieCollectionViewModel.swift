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

enum MoviesType {
    case upcoming
    case inCinema
}

protocol MovieCollectionViewModel: ViewModel {
    
    var dataSource: UICollectionViewDataSource & UICollectionViewDelegate  { get }
    var newIndexPaths: [IndexPath]? { get }
    
    func loadMore()
    func search(query: String)
    func stopSearch()
    func selectMovie(item: MovieViewModel)
    func switchType(_ type: MoviesType)
}

class InCinemaMovieCollectionViewModel: MovieCollectionViewModel {
    
    typealias Dependency = HasLocation & HasMDB & HasImageService & HasLocale
    
    private let dependency: Dependency
    private var model: MovieCollectionModel
    private var page = 1
    private var searchQuery: String? = nil
    private let collection: CollectionHandler
    private var type: MoviesType = .inCinema
    
    var title: String {
        return String.localize(key: "collection_title")
    }
    
    weak var viewDelegate: ViewDelegate?
    weak var coordinatorDelegate: MovieCollectionViewModelCoordinatorDelegate?
    
    init(model: MovieCollectionModel,
         dependency: Dependency,
         dataSource: CollectionHandler = CollectionHandler()) {
        self.model = model
        self.dependency = dependency
        self.collection = dataSource
    }
    
    // MARK: MovieCollection ViewModel
    
    var newIndexPaths: [IndexPath]?
    
    var dataSource: UICollectionViewDataSource & UICollectionViewDelegate {
        return self.collection
    }
    
    func loadMore() {
        if let searchQuery = searchQuery {
            self.model.search(query: searchQuery, page: page, than: handleLoadMore)
        } else {
            let region = dependency.currentLocation
            self.model.load(type: type, page: page, region: region, than: handleLoadMore)            
        }
    }
    
    func search(query: String) {
        searchQuery = query
        page = 1
        if query.count > 0 {
            loadMore()
        }
    }
    
    func stopSearch() {
        self.searchQuery = nil
        self.page = 1
        self.loadMore()
    }
    
    func selectMovie(item: MovieViewModel) {
        self.coordinatorDelegate?.viewModelDidSelectMovie(self, item: item)
    }
    
    func toViewModel(movie: Movie) -> MovieViewModel {
        let movieModel = InCinemaMovieModel(movie: movie, dependency: self.dependency)
        return InCinemaMovieViewModel(model: movieModel)
    }
    
    private func handleLoadMore(responce: ([Movie], Int)?, error: Error?) {
        guard let (data, total) = responce else {
            self.coordinatorDelegate?.viewModelDidThrowError(self, error: error)
            return
        }
        
        page += 1
        let newMovies = data.map(self.toViewModel)
        if page > 2 {
            self.newIndexPaths = self.collection.appendCollection(with: newMovies)
        } else {
            self.collection.resetCollection(with: newMovies, total: total)
        }

        self.viewDelegate?.itemsDidChange()
    }
    
    func switchType(_ type: MoviesType) {
        self.type = type
        loadMore()
    }
    
}

extension InCinemaMovieCollectionViewModel {
    func register(collectionView: UICollectionView, scrollDelegate: ScrollingToBottomDelegate, selectDelegate: SelectionDelegate) {
        collectionView.delegate = self.collection
        collectionView.dataSource = self.collection
        self.collection.scrollDelegate = scrollDelegate
        self.collection.selectionDelegate = selectDelegate
        collectionView.register(MovieCollectionCell.self, forCellWithReuseIdentifier: CollectionHandler.cellId)
        collectionView.register(MovieCollectionFooter.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: CollectionHandler.footerId)
        collectionView.register(MovieCollectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CollectionHandler.headerId)
    }
}
