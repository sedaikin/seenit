//
//  SearchScreenModel.swift
//  Seen it
//
//  Created by Rogova Mariya on 04.10.2025.
//

import Foundation

struct SearchScreenModel {
    var films: [FilmItem] = []
    var searchResults: [Film] = []
    var searchQuery: String = ""
    var isSearching: Bool = false
}
