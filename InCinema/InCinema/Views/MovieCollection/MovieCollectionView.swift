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
    
    init(viewModel: MovieCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        collection = UICollectionView(frame: CGRect.zero)
        collection.fill(container: self.view)
    }
    
    func itemsDidChange() {
        DispatchQueue.main.async {
            // TODO: update view
        }
    }
}
