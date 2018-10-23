//
//  NowInCinemaCoodrinator.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 23/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

class NowInCinemaCoodrinator: Coordinator {
    
    typealias Dependency
    
    let dependency: Dependency
    
    init(withViewController viewController: UIViewController,
         parentCoordinator coordinator: Coordinator?,
         dependency: Dependency) {
        self.dependency = dependency
        super.init(withViewController: viewController, andParentCoordinator: coordinator)
    }
    
    override func start() {
        guard
            let navigationController =  (rootViewController as? UINavigationController)
            else { return }
        
        let viewController: BitcoinIndexViewController = BitcoinIndexViewController(dependency: dependency)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
