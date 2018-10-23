//
//  AppCoordinator.swift
//  CoinDeskApp
//
//  Created by Vladimir Abramichev on 23/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

struct AppDependency {
}

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    let window: UIWindow?
    let dependency: AppDependency
    
    // MARK: - Coordinator
    init(window: UIWindow) {
        self.window = window
        self.dependency = AppDependency()
        super.init(withViewController: UINavigationController())
        
        window.rootViewController = self.rootViewController
        window.makeKeyAndVisible()
    }
    
    override func start() {
        let rootCoordinator = BitcoinIndexCoordinator(withViewController: self.rootViewController, parentCoordinator: self, dependency: dependency)
        rootCoordinator.start()
        self.childCoordinators.append(rootCoordinator)
    }
    
    override func finish() {
        
    }
    
}
