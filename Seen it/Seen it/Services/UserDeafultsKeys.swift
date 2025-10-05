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

    enum ProfileKeys: String {
        case firstName
        case lastName
        case email
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

    func saveUserProfile(firstName: String, lastName: String, email: String) {
        UserDefaults.standard.set(firstName, forKey: ProfileKeys.firstName.rawValue)
        UserDefaults.standard.set(lastName, forKey: ProfileKeys.lastName.rawValue)
        UserDefaults.standard.set(email, forKey: ProfileKeys.email.rawValue)
    }

    func getUserProfile() -> (firstName: String, lastName: String, email: String)? {
        guard let firstName = UserDefaults.standard.string(forKey: ProfileKeys.firstName.rawValue),
              let lastName = UserDefaults.standard.string(forKey: ProfileKeys.lastName.rawValue),
              let email = UserDefaults.standard.string(forKey: ProfileKeys.email.rawValue) else {
            return nil
        }
        return (firstName, lastName, email)
    }
}
