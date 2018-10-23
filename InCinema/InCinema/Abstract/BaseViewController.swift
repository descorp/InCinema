//
//  BaseViewController.swift
//  CoinDeskApp
//
//  Created by Vladimir Abramichev on 28/07/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
    }
}
