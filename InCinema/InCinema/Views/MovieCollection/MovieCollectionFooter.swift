//
//  MovieCollectionFooter.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 29/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

class MovieCollectionFooter: UICollectionReusableView {
    
    var loading: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        indicator.startAnimating()
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layout()
    }
    
    func layout() {
        let indicator = loading
        self.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.centerYAnchor.constraint(equalTo: indicator.centerYAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: indicator.centerXAnchor).isActive = true
    }
    
}
