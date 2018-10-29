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
    private var collection: UICollectionView!
    private var collectionHandler: CollectionHandler?
    
    init(viewModel: MovieCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        flowLayout.itemSize = CGSize(width: width / 2, height: 2 * width / 3)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        return flowLayout
    }()
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        
        collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.view.addSubview(collection)
        collection.fill(container: self.view)
        viewModel.loadMore()
    }
    
    func itemsDidChange() {
        DispatchQueue.main.sync {
            self.collectionHandler = CollectionHandler(collectionView: self.collection,
                                                       collection: self.viewModel.collection)
            self.collectionHandler?.scrollDelegate = self
            self.collection.reloadData()
        }
    }
}

extension MovieCollectionView: ScrollingToBottomDelegate {
    func didScrollToBottom() {
        self.viewModel.loadMore()
    }
}
