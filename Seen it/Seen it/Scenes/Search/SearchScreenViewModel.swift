//
//  SearchScreenViewModel.swift
//  Seen it
//
//  Created by Rogova Mariya on 04.10.2025.
//

import Foundation
import Combine

final class SearchScreenViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var searchState: SearchScreenModel = SearchScreenModel()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Private Properties
    private let networkManager: NetworkManager
    private let userDefaultsKeys: UserDefaultsKeys

    init(networkManager: NetworkManager = .shared,
         userDefaultsKeys: UserDefaultsKeys = UserDefaultsKeys()) {
        self.networkManager = networkManager
        self.userDefaultsKeys = userDefaultsKeys
    }

    // MARK: - Public Methods
    func loadPopularFilms() {
        isLoading = true

        networkManager.loadCollection(type: filmsCollection.topAll.type, page: 1) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success(let item):
                    self?.searchState.films = item.items
                case .failure(let error):
                    self?.errorMessage = "Ошибка загрузки популярных фильмов: \(error.localizedDescription)"
                }
            }
        }
    }

    func performSearch(query: String) {
        errorMessage = nil
        isLoading = true
        searchState.searchQuery = query
        
        networkManager.loadFilmsByKeyword(keyword: query, page: 1) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    self?.searchState.searchResults = response.films
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.errorMessage = "Ошибка поиска: \(error.localizedDescription)"
                    self?.searchState.searchResults = []
                }
            }
        }
    }

    func saveSearchState(query: String, results: [Film]) {
        guard !query.isEmpty && !results.isEmpty else { return }

        let filmIds = results.map { $0.filmId }
        userDefaultsKeys.saveLastSearchQuery(query)
        userDefaultsKeys.saveLastSearchResults(filmIds: filmIds)
    }

    func restoreSearchState() -> String? {
        return userDefaultsKeys.getLastSearchQuery()
    }

    func clearSearchState() {
        userDefaultsKeys.clearLastSearch()
    }

    func setSearching(_ isSearching: Bool) {
        searchState.isSearching = isSearching
    }

    func clearError() {
        errorMessage = nil
    }

    func clearSearch() {
        searchState.searchResults = []
        searchState.searchQuery = ""
        errorMessage = nil
        isLoading = false
    }
}
