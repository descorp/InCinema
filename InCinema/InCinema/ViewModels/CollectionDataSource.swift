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
    func didSelectItem(viewModel: MovieViewModel, at position: CGRect)
}

protocol TypeSelectoinDelegate: class {
    func typeDidSelected(_ type: MoviesType)
}

class CollectionHandler: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    static let cellId = "MovieCollectionCell"
    static let footerId = "MovieCollectionFooter"
    static let headerId = "MovieCollectionHeader"
    
    private var collection: [MovieViewModel]
    
    public weak var scrollDelegate: ScrollingToBottomDelegate?
    public weak var selectionDelegate: SelectionDelegate?
    public weak var typeDelegate: TypeSelectoinDelegate?
    
    init(collection: [MovieViewModel] = []) {
        self.collection = collection
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            self.scrollDelegate?.didScrollToBottom()
        }
        
        for movie in indexPaths.filter(isImageNotLoaded).map({ $0.item }) {
            collection[movie].loadImage(.poster)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionHandler.cellId, for: indexPath)
        if let movieCell = cell as? MovieCollectionCell {
            let viewModel = isLoadingCell(for: indexPath) ? nil : collection[indexPath.item]
            movieCell.bind(viewModel: viewModel)
        }
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == collection.count - 1 {
            self.scrollDelegate?.didScrollToBottom()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: CollectionHandler.headerId,
                                                                       for: indexPath)
            (view as? MovieCollectionHeader)?.delegate = self.typeDelegate
            return view
        }
        
       return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                              withReuseIdentifier: CollectionHandler.footerId,
                                                              for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = collection[indexPath.item]

        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let cellRect = attributes!.frame
        let position =  collectionView.convert(cellRect, to: collectionView.superview)

        self.selectionDelegate?.didSelectItem(viewModel: viewModel, at: position )
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
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.item >= collection.count
    }
    
    private func isImageNotLoaded(for indexPath: IndexPath) -> Bool {
        return indexPath.item < collection.count && collection[indexPath.item].posterImage == nil
    }
}
