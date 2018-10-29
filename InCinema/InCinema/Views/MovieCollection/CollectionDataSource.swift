//
//  CollectionDataSource.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 28/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

protocol ScrollingToBottomDelegate: class {
    func didScrollToBottom()
}

class CollectionHandler: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let cellId = "MovieCollectionCell"
    private let collection: [MovieViewModel]
    
    public weak var scrollDelegate: ScrollingToBottomDelegate?
    
    init(collectionView: UICollectionView, collection: [MovieViewModel]) {
        self.collection = collection
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        if let movieCell = cell as? MovieCollectionCell {
            movieCell.bind(viewModel: collection[indexPath.item])
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            self.scrollDelegate?.didScrollToBottom()
        }
    }
}

