//
//  ViewModel.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 25/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

protocol ViewModel: class {
}

protocol ViewDelegate: class {
    func itemsDidChange(viewModel: ViewModel)
}

protocol CoordinatorDelegate: class {
     func viewModelDidThrowError(_ viewModel: ViewModel, error: Error?)
}
