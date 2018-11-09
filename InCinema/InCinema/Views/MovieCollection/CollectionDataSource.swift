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

protocol SelectionDelegate: class {
    func didSelectItem(viewModel: MovieViewModel)
}

class CollectionHandler: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let cellId = "MovieCollectionCell"
    private let footerId = "MovieCollectionFooter"
    
    var collection: [MovieViewModel]
    
    public weak var scrollDelegate: ScrollingToBottomDelegate?
    public weak var selectionDelegate: SelectionDelegate?
    
    init(collectionView: UICollectionView, collection: [MovieViewModel] = []) {
        self.collection = collection
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(MovieCollectionFooter.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: footerId)
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == collection.count - 1 {
            self.scrollDelegate?.didScrollToBottom()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = collection[indexPath.item]
        self.selectionDelegate?.didSelectItem(viewModel: viewModel)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionCell {
            cell.higlight()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionCell {
            cell.unhiglight()
        }
    }
}

