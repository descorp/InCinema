//
//  MovieCollectionView.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 24/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

class MovieCollectionView: UICollectionViewController, ViewDelegate {
    
    private var viewModel: MovieCollectionViewModel
    
    init(viewModel: MovieCollectionViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize(width: width / 2, height: 3 *  width / 4)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.footerReferenceSize = CGSize(width: width, height: 100)
        return flowLayout
    }()
    
    private lazy var movieSearchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.placeholder = String.localize(key: "collection_search")
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barStyle = .blackTranslucent
        searchController.searchBar.tintColor = UIColor.white
        return searchController
    }()
    
    override func viewDidLoad() {
        self.navigationItem.title = viewModel.title
        self.navigationItem.searchController = movieSearchController
        
        self.view.backgroundColor = UIColor.black
        collectionView.allowsSelection = true        
        viewModel.loadMore()
    }
    
    func itemsDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self,
                  let newIndexPaths = strongSelf.viewModel.newIndexPaths
            else {
                self?.collectionView.reloadData()
                return
            }
            
            let indexPathToReload = strongSelf.visibleIndexPathsToReload(intersecting: newIndexPaths)
            strongSelf.collectionView.reloadItems(at: indexPathToReload)
        }
    }
    
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = self.collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

extension MovieCollectionView: ScrollingToBottomDelegate {
    func didScrollToBottom() {
        self.viewModel.loadMore()
    }
}

extension MovieCollectionView: SelectionDelegate {
    func didSelectItem(viewModel: MovieViewModel) {
        self.viewModel.selectMovie(item: viewModel)
    }
}

extension MovieCollectionView: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.viewModel.stopSearch()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.viewModel.search(query: text)
    }
}
