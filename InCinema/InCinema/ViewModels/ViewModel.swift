//
//  ViewModel.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 25/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

protocol ViewModel: class {
    var title: String { get }
}

protocol ViewDelegate: class {
    func itemsDidChange()
}

protocol CoordinatorDelegate: class {
     func viewModelDidThrowError(_ viewModel: ViewModel, error: Error?)
}
