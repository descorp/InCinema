//
//  FlowCoordinator.swift
//  CoinDeskApp
//
//  Created by Vladimir Abramichev on 28/07/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

class Coordinator {
    
    internal(set) var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: Coordinator?
    
    internal(set) var rootViewController: UIViewController
    
    internal init(withRootController viewController: UIViewController, andParentCoordinator parentCoordinator: Coordinator? = nil) {
        rootViewController = viewController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    func finish() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
}

extension Coordinator {

    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.index(of: coordinator) {
            childCoordinators.remove(at: index).finish()
        } else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }
    
    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        for coordinator in childCoordinators.filter({ $0 is T }) {
            removeChildCoordinator(coordinator)
        }
    }
    
    func removeAllChildCoordinators() {
        for coordinator in childCoordinators {
            coordinator.finish()
        }
        childCoordinators.removeAll()
    }
}

extension Coordinator: Equatable {
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
}
