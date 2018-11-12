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
    private var titleLabel: UILabel!
    
    private var movieTitleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
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
            guard
                let image = self.viewModel?.posterImage
            else {
                self.titleLabel.text = self.viewModel?.movieTitle
                return
            }
            
            if let existingImage = self.posterImage.image, existingImage.hash == image.hash {
                return
            }
            
            self.contentView.alpha = 0
            self.posterImage.image = image
            UIView.animateKeyframes(withDuration: 1, delay: 0,
                                    options: UIView.KeyframeAnimationOptions.calculationModeCubicPaced,
                                    animations: { [weak self] in self?.contentView.alpha = 1 }) { _ in }
        }
    }
    
    func bind(viewModel: MovieViewModel) {
        self.viewModel = viewModel
        viewModel.viewDelegate = self
        DispatchQueue.main.async { [weak self] in
            self?.posterImage.image = nil
        }
        viewModel.loadImage(.poster)
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
        titleLabel = movieTitleLabel
        self.contentView.addSubview(titleLabel)
        titleLabel.fill(container: self.contentView)
        
        posterImage = UIImageView(frame: CGRect.zero)
        self.contentView.addSubview(posterImage)
        posterImage.fill(container: self.contentView)
    }
    
}
