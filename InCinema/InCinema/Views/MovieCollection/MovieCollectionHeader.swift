//
//  MovieCollectionFooter.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 29/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

class MovieCollectionHeader: UICollectionReusableView {
    
    weak var delegate: TypeSelectoinDelegate?
    
    lazy var movieTypeSelector: UISegmentedControl = {
        let segment = UISegmentedControl(items: [String.localize(key: "in_cinema_title"),
                                                 String.localize(key: "upcoming_title")])
        segment.selectedSegmentIndex = 0
        segment.tintColor = UIColor.white
        segment.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)],
                                       for: UIControl.State.normal)
        segment.addTarget(self, action: #selector(segmentSelected(_:)) , for: UIControl.Event.valueChanged)
        return segment
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
        self.addSubview(movieTypeSelector)
        movieTypeSelector.fill(container: self, padding: UIEdgeInsets(top: 10, left: 36, bottom: 10, right: 36))
    }
    
    @objc func segmentSelected(_ control: UISegmentedControl) {
        let type: MoviesType = control.selectedSegmentIndex == 0 ? .inCinema : .upcoming
        self.delegate?.typeDidSelected(type)
    }
}
