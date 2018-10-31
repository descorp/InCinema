//
//  MovieDetails.swift
//  MDBProvider
//
//  Created by Vladimir Abramichev on 23/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation

import Foundation

public struct MovieDetails: Codable {
    public let adult: Bool
    public let belongsToCollection: BelongsToCollection?
    public let budget: Int
    public let genres: [Genre]
    public let id: Int
    public let originalLanguage, originalTitle: String
    public let popularity: Double
    public let productionCompanies: [ProductionCompany]
    public let productionCountries: [ProductionCountry]
    public let releaseDate: String
    public let revenue: Int
    public let spokenLanguages: [SpokenLanguage]
    public let status, title: String
    public let video: Bool
    public let voteAverage: Double
    public let voteCount: Int
    public let backdropPath, homepage, imdbID, overview, posterPath, tagline: String?
    public let runtime: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

public struct BelongsToCollection: Codable {
    public let id: Int
    public let name, posterPath, backdropPath: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

public struct Genre: Codable {
    public let id: Int
    public let name: String
}

public struct ProductionCompany: Codable {
    public let id: Int
    public let logoPath: String?
    public let name, originCountry: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

public struct ProductionCountry: Codable {
    public let iso3166_1, name: String
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

public struct SpokenLanguage: Codable {
    public let iso639_1, name: String
    
    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case name
    }
}
