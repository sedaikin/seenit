//
//  TrackedItem.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

struct TrackedItem:Decodable {
    let items: [FilmItem]
}

struct FilmItem: Decodable {
    let name: String
    let year: Int
    let duration: Int?
    let image: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "nameRu"
        case year = "year"
        case duration = "duration"
        case image = "posterUrl"
    }
}

// Временное место, потом поправлю когда буду знать как хранить данные на девайсе

struct IsTracked {
    let isTracked: Bool = false
}

