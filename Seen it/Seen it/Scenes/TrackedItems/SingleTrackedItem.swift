//
//  SingleTrackedItem.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 02.09.2025.
//

struct SingleTrackedItem: Decodable {
    let name: String
    let image: String
    let description: String
    let year: Int
    let duration: Int?
    
    private enum CodingKeys: String, CodingKey {
        case name = "nameRu"
        case image = "posterUrl"
        case description
        case year
        case duration = "filmLength"
    }
}


//{
//  "kinopoiskId": 6989814,
//  "kinopoiskHDId": "7c9d28e328e04472accfe0258236a1a0",
//  "imdbId": null,
//  "nameRu": "Зальцбург: Сказки Гофмана",
//  "nameEn": null,
//  "nameOriginal": "Salzburg Festival: Les Contes d’Hoffmann",
//  "posterUrl": "https://kinopoiskapiunofficial.tech/images/posters/kp/6989814.jpg",
//  "posterUrlPreview": "https://kinopoiskapiunofficial.tech/images/posters/kp_small/6989814.jpg",
//  "coverUrl": "https://avatars.mds.yandex.net/get-ott/1531675/2a00000194ac79abd68b2155a19d71042d9b/orig",
//  "logoUrl": null,
//  "reviewsCount": 0,
//  "ratingGoodReview": null,
//  "ratingGoodReviewVoteCount": 0,
//  "ratingKinopoisk": null,
//  "ratingKinopoiskVoteCount": 16,
//  "ratingImdb": null,
//  "ratingImdbVoteCount": 0,
//  "ratingFilmCritics": null,
//  "ratingFilmCriticsVoteCount": 0,
//  "ratingAwait": null,
//  "ratingAwaitCount": 0,
//  "ratingRfCritics": null,
//  "ratingRfCriticsVoteCount": 0,
//  "webUrl": "https://www.kinopoisk.ru/film/6989814/",
//  "year": 2024,
//  "filmLength": 192,
//  "slogan": null,
//  "description": "Постановка оперы Жака Оффенбаха.",
//  "shortDescription": null,
//  "editorAnnotation": null,
//  "isTicketsAvailable": false,
//  "productionStatus": null,
//  "type": "FILM",
//  "ratingMpaa": null,
//  "ratingAgeLimits": "age18",
//  "countries": [
//    {
//      "country": "Австрия"
//    }
//  ],
//  "genres": [
//    {
//      "genre": "драма"
//    }
//  ],
//  "startYear": null,
//  "endYear": null,
//  "serial": false,
//  "shortFilm": false,
//  "completed": false,
//  "hasImax": false,
//  "has3D": false,
//  "lastSync": "2025-07-29T23:12:11.252127"
//}
