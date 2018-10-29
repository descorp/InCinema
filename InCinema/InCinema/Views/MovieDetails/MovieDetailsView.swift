//
//  MovieDetailsView.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 24/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailsView: UIViewController, ViewDelegate {
    
    private var titleLabel: UILabel!
    private var backdropImage: UIImageView!
    private var descriptionLabel: UILabel!
    
    internal var movieTitle: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.numberOfLines = 0
        return lable
    }()
    
    internal var movieDescription: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.numberOfLines = 0
        return lable
    }()
    
    internal var movieBackdrop: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var viewModel: MovieViewModel
    
    init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.title = String.localize(key: "details_title")
        self.view.backgroundColor = UIColor.black
        self.view.layoutMargins = UIEdgeInsets(top: 64,
                                               left: self.view.layoutMargins.left,
                                               bottom: self.view.layoutMargins.bottom,
                                               right: self.view.layoutMargins.right)
        
        self.titleLabel = movieTitle
        self.backdropImage = movieBackdrop
        self.descriptionLabel = movieDescription
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(backdropImage)
        self.view.addSubview(descriptionLabel)
        
        let views: [String: UIView] = ["image": backdropImage, "title": titleLabel, "description": descriptionLabel]
        let width = UIScreen.main.bounds.width
        if #available(iOS 11.0, *) {
            self.backdropImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            // TODO: fix top margin for iOS <11
            self.view.layoutMargins = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
            self.backdropImage.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor).isActive = true
        }
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[image(\(width * 0.56))]-[title]-[description]", options: [], metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[image]-0-|", options: [], metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[title]-16-|", options: [], metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[description]-16-|", options: [], metrics: nil, views: views))
        descriptionLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.vertical)
        viewModel.loadImage(.backdrop)
    }
    
    func itemsDidChange() {
        DispatchQueue.main.async { [weak self] in
            self?.backdropImage.image = self?.viewModel.backdropImage
            self?.titleLabel.text = self?.viewModel.title
            self?.descriptionLabel.text = self?.viewModel.plotDescription
        }
    }
    
}
