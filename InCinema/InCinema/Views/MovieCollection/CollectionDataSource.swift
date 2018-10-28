//
//  CollectionDataSource.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 28/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

class CollectionHandler: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let cellId = ""
    private let collection: [MovieViewModel]
    
    init(collection: [MovieViewModel]) {
        self.collection = collection
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
}

