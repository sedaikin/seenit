//
//  SingleTrackedItem.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 02.09.2025.
//

struct SingleTrackedItem: Decodable {
    let id: Int
    let name: String
    let image: String
    let description: String
    let year: Int
    let duration: Int?
    let ratingImdb: Double?
    let ratingKinopoisk: Double?
    let genres: [Genres]
    let type: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "kinopoiskId"
        case name = "nameRu"
        case image = "posterUrl"
        case description
        case year
        case duration = "filmLength"
        case ratingImdb
        case ratingKinopoisk
        case genres
        case type
    }
}

struct Genres: Decodable {
    let genre: String
}
