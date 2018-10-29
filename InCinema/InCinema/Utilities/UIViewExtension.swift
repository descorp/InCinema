//
//  UIViewExtension.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 28/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func fill(container: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let views = ["view": self]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:[], metrics:nil, views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:[], metrics:nil, views: views)
        container.addConstraints(horizontal)
        container.addConstraints(vertical)
    }    
}
