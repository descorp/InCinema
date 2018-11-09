//
//  MovieCollectionView.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 24/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

class MovieCollectionView: UIViewController, ViewDelegate {
    
    private var viewModel: MovieCollectionViewModel
    private var collectionView: UICollectionView!
    private var collectionHandler: CollectionHandler?
    
    init(viewModel: MovieCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
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
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.allowsSelection = true
        self.view.addSubview(collectionView)
        collectionView.fill(container: self.view)
        
        self.collectionHandler = CollectionHandler(collectionView: self.collectionView)
        self.collectionHandler?.scrollDelegate = self
        self.collectionHandler?.selectionDelegate = self
        viewModel.loadMore()
    }
    
    func itemsDidChange() {
        DispatchQueue.main.async {
            self.collectionHandler?.collection = self.viewModel.collection
            self.collectionView.reloadData()
        }
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
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch(_:)) , object: nil)
        self.perform(#selector(performSearch(_:)), with: searchController.searchBar, afterDelay: 0.5)
    }
    
    @objc func performSearch(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.viewModel.search(query: text)
    }
}
