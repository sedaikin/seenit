//
//  KeyboardResponse.swift
//  Seen it
//
//  Created by Rogova Mariya on 14.09.2025.
//

struct KeyboardResponse: Decodable {
    let keyword: String
    let pagesCount: Int
    let films: [Film]
}

struct Film: Decodable {
    let filmId: Int
    let nameRu: String?
    let nameEn: String?
    let type: String
    let year: String?
    let description: String?
    let filmLength: String?
    let countries: [Country]?
}

struct Country: Codable {
    let country: String
}
