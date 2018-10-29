//
//  MovieDetailsCoordinator.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 25/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import MDBProvider

class MovieDetailsCoordinator: Coordinator, CoordinatorDelegate {
    
    private let viewModel: MovieViewModel
    
    init(viewModel: MovieViewModel,
        withViewController viewController: UIViewController,
        andParentCoordinator parentCoordinator: Coordinator?) {
        self.viewModel = viewModel
        super.init(withRootController: viewController, andParentCoordinator: parentCoordinator)
    }
    
    override func start() {
        guard
            let navigationController =  (rootViewController as? UINavigationController)
        else { return }
        
        let viewController = MovieDetailsView(viewModel: viewModel)
        viewModel.viewDelegate = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    override func finish() {
        guard
            let navigationController =  (rootViewController as? UINavigationController)
        else { return }
        
        navigationController.isNavigationBarHidden = false
        navigationController.popViewController(animated: true)
    }
    
    func viewModelDidThrowError(_ viewModel: ViewModel, error: Error?) {
    }
    
}
