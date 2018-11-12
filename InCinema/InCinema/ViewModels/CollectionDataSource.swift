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

class CollectionHandler: NSObject, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegate {
    
    static let cellId = "MovieCollectionCell"
    static let footerId = "MovieCollectionFooter"
    
    private var collection: [MovieViewModel]
    private var total: Int
    
    public weak var scrollDelegate: ScrollingToBottomDelegate?
    public weak var selectionDelegate: SelectionDelegate?
    
    init(collection: [MovieViewModel] = []) {
        self.collection = collection
        self.total = collection.count
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return total
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: hasCell) {
            self.scrollDelegate?.didScrollToBottom()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionHandler.cellId, for: indexPath)
        if !hasCell(for: indexPath), let movieCell = cell as? MovieCollectionCell {
            movieCell.bind(viewModel: collection[indexPath.item])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                               withReuseIdentifier: CollectionHandler.footerId,
                                                               for: indexPath)
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
    
    // MARK: collection access
    
    func appendCollection(with newItems: [MovieViewModel]) -> [IndexPath] {
        let startIndex = collection.count - newItems.count
        let endIndex = startIndex + newItems.count
        collection.append(contentsOf: newItems)
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func resetCollection(with newItems: [MovieViewModel], total: Int) {
        self.collection = newItems
        self.total = total
    }
    
    private func hasCell(for indexPath: IndexPath) -> Bool {
        return indexPath.item >= collection.count
    }
}
