//
//  MovieCollectionHeader.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 29/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

class MovieCollectionHeader: UICollectionReusableView {
    
    private var movieLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.text = String.localize(key: "collection_title")
        return label
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
        let label = movieLabel
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view]-|", options: [],
                                                           metrics: nil, views: ["view": label]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[view]", options: [],
                                                          metrics: nil, views: ["view": label]))
    }
    
}
