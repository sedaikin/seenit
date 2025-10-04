//
//  UserDeafultsKeys.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 14.09.2025.
//

import Foundation

struct UserDefaultsKeys {
    enum ListType: String {
        case tracked
        case watched
    }

    enum SearchKeys: String {
        case lastSearchQuery
        case lastSearchResults
    }

    func addMovieId(_ movieId: Int, to list: ListType) {
        var movies = getMovieIds(for: list)
        if !movies.contains(movieId) {
            movies.append(movieId)
            saveMovieIds(movies, for: list)
        }
    }
    
    func removeMovieId(_ movieId: Int, from list: ListType) {
        var movies = getMovieIds(for: list)
        movies.removeAll { $0 == movieId }
        saveMovieIds(movies, for: list)
    }
    
    func containsMovieId(_ movieId: Int, in list: ListType) -> Bool {
        getMovieIds(for: list).contains(movieId)
    }
    
    func getMovieIds(for list: ListType) -> [Int] {
        UserDefaults.standard.array(forKey: list.rawValue) as? [Int] ?? []
    }
    
    private func saveMovieIds(_ movieIds: [Int], for list: ListType) {
        UserDefaults.standard.set(movieIds, forKey: list.rawValue)
    }

    func saveLastSearchQuery(_ query: String) {
        UserDefaults.standard.set(query, forKey: SearchKeys.lastSearchQuery.rawValue)
    }
    
    func getLastSearchQuery() -> String? {
        UserDefaults.standard.string(forKey: SearchKeys.lastSearchQuery.rawValue)
    }
    
    func saveLastSearchResults(filmIds: [Int]) {
        UserDefaults.standard.set(filmIds, forKey: SearchKeys.lastSearchResults.rawValue)
    }
    
    func getLastSearchResults() -> [Int] {
        UserDefaults.standard.array(forKey: SearchKeys.lastSearchResults.rawValue) as? [Int] ?? []
    }
    
    func clearLastSearch() {
        UserDefaults.standard.removeObject(forKey: SearchKeys.lastSearchQuery.rawValue)
        UserDefaults.standard.removeObject(forKey: SearchKeys.lastSearchResults.rawValue)
    }
}
