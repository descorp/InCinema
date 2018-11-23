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
        
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.barStyle = .blackTranslucent
        navigationController.navigationBar.prefersLargeTitles = true
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
    
    private lazy var model = {
        return InCinemaMovieCollectionModel(dependency: dependency)
    }()
    
    private lazy var viewModel: InCinemaMovieCollectionViewModel = {
        let viewModel = InCinemaMovieCollectionViewModel(model: model, dependency: dependency)
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    private lazy var viewController: MovieCollectionView = {
        let viewController = MovieCollectionView(viewModel: viewModel)
        viewModel.viewDelegate = viewController
        viewModel.register(collectionView: viewController.collectionView,
                           scrollDelegate: viewController,
                           selectDelegate: viewController,
                           typeDelegate: viewModel)
        return viewController
    }()
}
