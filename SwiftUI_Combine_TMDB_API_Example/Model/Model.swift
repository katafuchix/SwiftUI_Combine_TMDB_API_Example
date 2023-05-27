//
//  Model.swift
//  SwiftUI_Combine_TMDB_API_Example
//
//  Created by cano on 2023/05/27.
//

import Foundation

struct MovieResponse: Codable {
    let movies: [Movie]

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
    
}

struct Movie: Codable, Identifiable {
    var id = UUID()
    let movieId: Int
    let originalTitle: String
    let title: String
    let poster_path: String
    
    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case originalTitle = "original_title"
        case title
        case poster_path
    }
    
    var thumbImageUrl: URL? { return URL(string: "https://image.tmdb.org/t/p/w300_and_h450_bestv2/\(poster_path)") }
}
