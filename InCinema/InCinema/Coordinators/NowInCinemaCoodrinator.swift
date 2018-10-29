//
//  NowInCinemaCoodrinator.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 23/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit
import MDBProvider

class NowInCinemaCoodrinator: Coordinator, MovieCollectionViewModelCoordinatorDelegate {
    typealias Dependency = HasLocation & HasMDB & HasLocale & HasImageService
    
    let dependency: Dependency
    
    init(withViewController viewController: UIViewController,
         parentCoordinator coordinator: Coordinator?,
         dependency: Dependency) {
        self.dependency = dependency
        super.init(withRootController: viewController, andParentCoordinator: coordinator)
    }
    
    override func start() {
        guard
            let navigationController =  (rootViewController as? UINavigationController)
        else { return }
        
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        
        let model = InCinemaMovieCollectionModel(dependency: dependency)
        let viewModel = InCinemaMovieCollectionViewModel(model: model,
                                                         dependency: dependency)
        viewModel.coordinatorDelegate = self
        let viewController = MovieCollectionView(viewModel: viewModel)
        viewModel.viewDelegate = viewController
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func viewModelDidSelectMovie(_ viewModel: ViewModel, item: MovieViewModel) {
        let detailCoordinator = MovieDetailsCoordinator(viewModel: item,
                                                        withViewController: rootViewController,
                                                        andParentCoordinator: self)
        self.addChildCoordinator(detailCoordinator)
        detailCoordinator.start()
    }
    
    func viewModelDidThrowError(_ viewModel: ViewModel, error: Error?) {
        // TODO: Show Error
    }
}
