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
    
    private let dependency: Dependency
    private var root: UINavigationController!
    
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

        root = navigationController
        root.navigationBar.tintColor = UIColor.white
        root.navigationBar.barStyle = .blackTranslucent
        root.navigationBar.prefersLargeTitles = true
        root.setViewControllers([viewController], animated: false)
    }
    
    func viewModelDidSelectMovie(_ viewModel: ViewModel, item: MovieViewModel, at position: CGRect) {
        let detailCoordinator = MovieDetailsCoordinator(viewModel: item,
                                                        origin: position,
                                                        withViewController: rootViewController,
                                                        andParentCoordinator: self)
        self.addChildCoordinator(detailCoordinator)
        detailCoordinator.start()
    }
    
    func viewModelDidThrowError(_ viewModel: ViewModel, error: Error?) {
        DispatchQueue.main.async {
            self.root.viewControllers = [ErrorView(error: error!)]
        }
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
