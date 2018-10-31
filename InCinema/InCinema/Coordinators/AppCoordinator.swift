//
//  AppCoordinator.swift
//  CoinDeskApp
//
//  Created by Vladimir Abramichev on 23/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import UIKit

struct AppDependency: HasMDB, HasLocation, HasLocale, HasImageService {
    func load(path: String, than handler: @escaping (UIImage?, Error?) -> Void) {
        imageLoader.load(path: path, than: handler)
    }
    
    var currentLocation: String {
        return locationService.currentLocation
    }
    
    var currentLocale: String {
        return localeService.currentLocale
    }
    
    let moviesService: IMoviesProvider
    let locationService: LocationService
    let localeService: LocaleService
    let imageLoader: ImageService
}

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    let window: UIWindow?
    let dependency: AppDependency
    
    // MARK: - Coordinator
    init(window: UIWindow) {
        self.window = window
        let config = EnvironmentConfiguration()
        let mdbService: MoviesService = MoviesService(apiKey: config.appKey)
        self.dependency = AppDependency(moviesService: mdbService,
                                        locationService: LocationService(),
                                        localeService: LocaleService(),
                                        imageLoader: ImageService(imageLoader: mdbService))
        super.init(withRootController: UINavigationController())
        
        window.rootViewController = self.rootViewController
        window.makeKeyAndVisible()
    }
    
    override func start() {
        let rootCoordinator = NowInCinemaCoodrinator(withViewController: self.rootViewController,
                                                     parentCoordinator: self,
                                                     dependency: dependency)
        self.childCoordinators.append(rootCoordinator)
        rootCoordinator.start()
    }
    
    override func finish() {
        
    }
    
}
