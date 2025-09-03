//
//  TrackedItem.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

struct TrackedItem: Decodable {
    let items: [FilmItem]
}

struct FilmItem: Decodable {
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

struct IsTracked {
    let isTracked: Bool = false
}

//{
//  "total": 60,
//  "items": [
//    {
//      "kinopoiskId": 5047471,
//      "nameRu": "Волшебник Изумрудного города. Дорога из жёлтого кирпича",
//      "nameEn": "",
//      "year": 2024,
//      "posterUrl": "https://kinopoiskapiunofficial.tech/images/posters/kp/5047471.jpg",
//      "posterUrlPreview": "https://kinopoiskapiunofficial.tech/images/posters/kp_small/5047471.jpg",
//      "countries": [
//        {
//          "country": "Россия"
//        }
//      ],
//      "genres": [
//        {
//          "genre": "фэнтези"
//        },
//        {
//          "genre": "приключения"
//        },
//        {
//          "genre": "семейный"
//        }
//      ],
//      "duration": 104,
//      "premiereRu": "2025-01-01"
//    },
//    ]
