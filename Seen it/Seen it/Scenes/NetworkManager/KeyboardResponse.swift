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

extension Film {
    func toFilmItem() -> FilmItem {
        return FilmItem(
            id: self.filmId,
            name: self.nameRu ?? self.nameEn ?? "Без названия",
            year: Int(self.year ?? "0") ?? 0,
            duration: self.filmLength?.toMinutes(),
            image: ""
        )
    }
}

extension String {
    func toMinutes() -> Int? {
        let components = self.split(separator: ":")
        guard components.count >= 2,
              let hours = Int(components[0]),
              let minutes = Int(components[1]) else {
            return nil
        }
        return hours * 60 + minutes
    }
}

