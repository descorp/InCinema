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
    func getMoviesInCinema(region: String, page: Int, than handler: @escaping ([Movie]?, Error?) -> Void)
    func getMovie(id: Int, than handler: @escaping (MovieDetails?, Error?) -> Void)
    func search(query: String, than handler: @escaping ([Movie]?, Error?) -> Void)
}

protocol HasMDB {
    var moviesService: IMoviesProvider { get }
}

class MoviesService: IMoviesProvider {
    private let provider: MDBProvider
    
    init(apiKey: String) {
        self.provider = MDBProvider(apiKey: apiKey)
    }
    
    func getMoviesInCinema(region: String, page: Int = 0, than handler: @escaping ([Movie]?, Error?) -> Void) {
        self.provider.request(Endpoint.nowPlaying(page: page, region: region)) { result in
            switch result {
            case .success(let responce):
                handler(responce.results, nil)
            case .failure(let error):
                handler(nil, error)
            }
        }
    }
    
    func getMovie(id: Int, than handler: @escaping (MovieDetails?, Error?) -> Void) {
        self.provider.request(Endpoint.getMovie(id: id)) { result in
            switch result {
            case .success(let responce):
                handler(responce, nil)
            case .failure(let error):
                handler(nil, error)
            }
        }
    }
    
    func search(query: String, than handler: @escaping ([Movie]?, Error?) -> Void) {
        self.provider.request(Endpoint.searchMovie(query: query)) { result in
            switch result {
            case .success(let responce):
                handler(responce.results, nil)
            case .failure(let error):
                handler(nil, error)
            }
        }
    }

}

