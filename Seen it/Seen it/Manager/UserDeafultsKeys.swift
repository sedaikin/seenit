//
//  UserDeafultsKeys.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 14.09.2025.
//

import UIKit

struct UserDefaultsKeys {
    enum ListType: String {
        case tracked = "tracked"
        case watched = "watched"
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
        return getMovieIds(for: list).contains(movieId)
    }
    
    func getMovieIds(for list: ListType) -> [Int] {
        return UserDefaults.standard.array(forKey: list.rawValue) as? [Int] ?? []
    }
    
    private func saveMovieIds(_ movieIds: [Int], for list: ListType) {
        UserDefaults.standard.set(movieIds, forKey: list.rawValue)
    }
}
