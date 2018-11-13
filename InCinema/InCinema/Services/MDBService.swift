//
//  MDBService.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 23/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import MDBProvider

protocol IMoviesProvider {
    func getMoviesInCinema(region: String, page: Int, language: String, than handler: @escaping (([Movie], Int)?, Error?) -> Void)
    func getMovie(id: Int, language: String, than handler: @escaping (MovieDetails?, Error?) -> Void)
    func search(query: String, language: String, page: Int, than handler: @escaping (([Movie], Int)?, Error?) -> Void)
}

protocol HasImageLoader {
    func loadImage(path: String, than handler: @escaping (Data?, Error?) -> Void)
}

protocol HasMDB {
    var moviesService: IMoviesProvider { get }
}

class MoviesService: IMoviesProvider, HasImageLoader {

    private let provider: MDBProvider
    
    init(apiKey: String) {
        self.provider = MDBProvider(apiKey: apiKey)
    }
    
    func getMoviesInCinema(region: String, page: Int = 0, language: String, than handler: @escaping (([Movie], Int)?, Error?) -> Void) {
        self.provider.request(Endpoint.nowPlaying(page: page, region: region)) { result in
            switch result {
            case .success(let responce):
                handler((responce.results, responce.totalResults), nil)
            case .failure(let error):
                handler(nil, error)
            }
        }
    }
    
    func getMovie(id: Int, language: String, than handler: @escaping (MovieDetails?, Error?) -> Void) {
        self.provider.request(Endpoint.getMovie(id: id)) { result in
            switch result {
            case .success(let responce):
                handler(responce, nil)
            case .failure(let error):
                handler(nil, error)
            }
        }
    }
    
    func search(query: String, language: String, page: Int = 1, than handler: @escaping (([Movie], Int)?, Error?) -> Void) {
        self.provider.request(Endpoint.searchMovie(query: query)) { result in
            switch result {
            case .success(let responce):
                handler((responce.results, responce.totalResults), nil)
            case .failure(let error):
                handler(nil, error)
            }
        }
    }

    func loadImage(path: String, than handler: @escaping (Data?, Error?) -> Void) {
        self.provider.request(Endpoint.loadImageData(path: path, size: .w500)) { (result) in
            switch result {
            case .success(let responce):
                handler(responce, nil)
            case .failure(let error):
                handler(nil, error)
            }
        }
    }
}

