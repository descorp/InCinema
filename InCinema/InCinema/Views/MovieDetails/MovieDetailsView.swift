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
    
    internal lazy var movieTitle: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.numberOfLines = 0
        return lable
    }()
    
    internal lazy var movieDescription: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.numberOfLines = 0
        return lable
    }()
    
    internal lazy var movieBackdrop: UIImageView = {
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
        self.title = viewModel.title
        self.view.backgroundColor = UIColor.black
        
        self.view.addSubview(movieTitle)
        self.view.addSubview(movieBackdrop)
        self.view.addSubview(movieDescription)
        
        let views: [String: UIView] = ["image": movieBackdrop, "title": movieTitle, "description": movieDescription]
        let width = UIScreen.main.bounds.width
        if #available(iOS 11.0, *) {
            self.movieBackdrop.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            self.movieBackdrop.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        }
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[image(\(width * 0.56))]-[title]-[description]", options: [], metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[image]-0-|", options: [], metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[title]-16-|", options: [], metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[description]-16-|", options: [], metrics: nil, views: views))
        movieDescription.setContentHuggingPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.vertical)
        viewModel.loadImage(.backdrop)
    }
    
    func itemsDidChange() {
        DispatchQueue.main.async { [weak self] in
            self?.movieBackdrop.image = self?.viewModel.backdropImage
            self?.movieTitle.text = self?.viewModel.movieTitle
            self?.movieDescription.text = self?.viewModel.plotDescription
        }
    }
    
}
