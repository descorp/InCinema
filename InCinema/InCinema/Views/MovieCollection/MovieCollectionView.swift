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
    
    private var searchBar: UISearchBar!
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
        flowLayout.headerReferenceSize = CGSize(width: width, height: 100)
        flowLayout.footerReferenceSize = CGSize(width: width, height: 100)
        return flowLayout
    }()
    
    private lazy var movieSearchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect.zero)
        searchBar.showsCancelButton = true
        searchBar.placeholder = String.localize(key: "collection_search")
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .blackTranslucent
        searchBar.tintColor = UIColor.white
        return searchBar
    }()
    
    override func viewDidLoad() {
        searchBar = movieSearchBar
        self.navigationItem.titleView = searchBar
        
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

extension MovieCollectionView: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.stopSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // to limit network activity, reload half a second after last key press.
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch) , object: nil)
        self.perform(#selector(performSearch), with: nil, afterDelay: 0.5)
    }
    
    @objc func performSearch() {
        guard let text = searchBar.text else { return }
        self.viewModel.search(query: text)
    }
}
