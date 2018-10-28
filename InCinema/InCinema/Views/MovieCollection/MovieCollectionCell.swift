//
//  MovieCollectionCell.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 28/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

class MovieCollectionCell: UICollectionViewCell, ViewDelegate {
    
    private var backdropImage: UIImageView!
    private weak var viewModel: MovieViewModel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layout()
    }
    
    func itemsDidChange() {
        backdropImage.image = viewModel?.backdropImage
    }
    
    func bind(viewModel: MovieViewModel) {
        self.viewModel = viewModel
        viewModel.viewDelegate = self
    
        if viewModel.backdropImage == nil {
            viewModel.loadImage()
        } else {
            itemsDidChange()
        }
    }
 
    private func layout() {
        backdropImage = UIImageView(frame: CGRect.zero)
        backdropImage.fill(container: self.contentView)
    }
}
