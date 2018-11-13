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
    
    private weak var viewModel: MovieViewModel? {
        didSet{
            self.viewModel?.viewDelegate = self
            self.itemsDidChange()
        }
    }
    
    private lazy var movieTitleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        self.contentView.addSubview(titleLabel)
        titleLabel.fill(container: self.contentView)
        return titleLabel
    }()
    
    private lazy var posterImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        self.contentView.addSubview(imageView)
        imageView.fill(container: self.contentView)
        self.contentView.sendSubviewToBack(imageView)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func itemsDidChange() {        
        DispatchQueue.main.async { [weak self] in
            guard
                let strongSelf = self,
                let viewModel = strongSelf.viewModel
            else {
                self?.movieTitleLabel.text = nil
                self?.posterImage.image = nil
                return
            }
            
            strongSelf.movieTitleLabel.text = viewModel.movieTitle
            guard let _ = viewModel.posterNotAvailable else {
                strongSelf.posterImage.alpha = 0
                strongSelf.viewModel?.loadImage(.poster)
                return
            }
            
            if let image = viewModel.posterImage {
                strongSelf.posterImage.contentMode = .scaleAspectFill
                strongSelf.posterImage.image = image
                strongSelf.movieTitleLabel.alpha = 0
            } else {
                strongSelf.posterImage.contentMode = .center
                strongSelf.movieTitleLabel.alpha = 1
                strongSelf.posterImage.image = UIImage(named: "poster_placeholder")
            }
            
            UIView.animateKeyframes(withDuration: 1, delay: 0,
                                    options: UIView.KeyframeAnimationOptions.calculationModeCubicPaced,
                                    animations: { [weak self] in
                                        self?.posterImage.alpha = 1
            }) { _ in }
        }
    }
    
    func bind(viewModel: MovieViewModel?) {
        self.viewModel = viewModel
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
}
