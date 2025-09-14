//
//  NetworkManager.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 26.08.2025.
//

import Foundation

enum filmsCollection {
    case topAll
    case topMovies
    case topShows

    var type: String {
        switch self {
            case .topAll: return "TOP_POPULAR_ALL"
            case .topMovies: return "TOP_POPULAR_MOVIES"
            case .topShows: return "TOP_250_TV_SHOWS"
        }
    }
}

final class NetworkManager {
    static let apiKey = "230cc843-7dc4-4550-a211-8b4659c59e1f"

    static let shared = NetworkManager()

    private init() {}
    
    func loadData(completion: @escaping (Result<TrackedItem, Error>) -> Void) {
        guard let url = URL(string: "https://kinopoiskapiunofficial.tech/api/v2.2/films/premieres?year=2025&month=JANUARY") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Self.apiKey, forHTTPHeaderField: "X-API-KEY")

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print(error)
                return
            }
            
            guard let data else {
                print("no data")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let trackedItem = try decoder.decode(TrackedItem.self, from: data)
                completion(.success(trackedItem))
            } catch {
                print(error)
            }
        }
        
        dataTask.resume()
    }
    
    func loadSingleData(id: Int, completion: @escaping (Result<SingleTrackedItem, Error>) -> Void) {
        guard let url = URL(string: "https://kinopoiskapiunofficial.tech/api/v2.2/films/\(id)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Self.apiKey, forHTTPHeaderField: "X-API-KEY")

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print(error)
                return
            }
            
            guard let data else {
                print("no data")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let trackedItem = try decoder.decode(SingleTrackedItem.self, from: data)
                completion(.success(trackedItem))
            } catch {
                print(error)
            }
        }

        dataTask.resume()
    }

    func loadCollection(type: String, page: Int, completion: @escaping (Result<TrackedItem, Error>) -> Void) {
        guard let url = URL(string: "https://kinopoiskapiunofficial.tech/api/v2.2/films/collections?type=\(type)&page=\(page)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Self.apiKey, forHTTPHeaderField: "X-API-KEY")

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print(error)
                return
            }

            guard let data else {
                print("no data")
                return
            }

            let decoder = JSONDecoder()
            do {
                let trackedItem = try decoder.decode(TrackedItem.self, from: data)
                completion(.success(trackedItem))
            } catch {
                print(error)
            }
        }

        dataTask.resume()
    }

    func loadFilmsByKeyword(keyword: String, completion: @escaping (Result<KeyboardResponse, Error>) -> Void) {
        guard let url = URL(string: "https://kinopoiskapiunofficial.tech//api/v2.1/films/search-by-keyword/?keyword=\(keyword)&page=1") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Self.apiKey, forHTTPHeaderField: "X-API-KEY")

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print(error)
                return
            }

            guard let data else {
                print("no data")
                return
            }

            let decoder = JSONDecoder()
            do {
                let film = try decoder.decode(KeyboardResponse.self, from: data)
                completion(.success(film))
            } catch {
                print(error)
            }
        }

        dataTask.resume()
    }

}
