//
//  TrackedItem.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

struct TrackedItem: Decodable {
    let items: [FilmItem]
}

struct FilmItem: Decodable, Hashable {
    let id: Int
    let name: String
    let year: Int
    let duration: Int?
    let image: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "kinopoiskId"
        case name = "nameRu"
        case year = "year"
        case duration = "duration"
        case image = "posterUrl"
    }
}

