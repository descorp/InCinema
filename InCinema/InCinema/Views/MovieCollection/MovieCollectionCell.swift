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
    
    private weak var viewModel: MovieViewModel?
    private var posterImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layout()
    }
    
    func itemsDidChange() {        
        DispatchQueue.main.async {
            self.contentView.alpha = 0
            UIView.animateKeyframes(withDuration: 1, delay: 0,
                                    options: UIView.KeyframeAnimationOptions.calculationModeCubicPaced,
                                    animations: { [weak self] in
                                        self?.contentView.alpha = 1
                                        self?.posterImage.image = self?.viewModel?.posterImage
            }) { _ in }
        }
    }
    
    func bind(viewModel: MovieViewModel) {
        self.viewModel = viewModel
        viewModel.viewDelegate = self
    
        if viewModel.posterImage == nil {
            viewModel.loadImage(.poster)
        } else {
            itemsDidChange()
        }
    }
    
    func higlight() {
        UIView.animate(withDuration: 0.5) {
            self.posterImage.transform = .init(scaleX: 0.95, y: 0.95)
        }
    }
    
    func unhiglight() {
        UIView.animate(withDuration: 0.5) {
            self.posterImage.transform = .identity            
        }
    }
 
    private func layout() {
        posterImage = UIImageView(frame: CGRect.zero)
        self.contentView.addSubview(posterImage)
        posterImage.fill(container: self.contentView)
    }
    
}
