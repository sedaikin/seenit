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

enum NetworkError: Error {
    case invalidURL
    case noData
    case serverError(statusCode: Int)
    case decodingError
}

final class NetworkManager {
    static let apiKey = "0a4295d8-96b2-4396-9eee-4adbe7abd394"
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func loadData(completion: @escaping (Result<TrackedItemModel, Error>) -> Void) {
        guard let url = URL(string: "https://kinopoiskapiunofficial.tech/api/v2.2/films/premieres?year=\(Calendar.current.component(.year, from: Date()))&month=JANUARY") else {
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
                let trackedItem = try decoder.decode(TrackedItemModel.self, from: data)
                completion(.success(trackedItem))
            } catch {
                print(error)
            }
        }
        
        dataTask.resume()
    }
    
    func loadDataForIds(_ ids: [Int], completion: @escaping ([DetailScreenModel]) -> Void) {
       var loadedItems: [DetailScreenModel] = []
       let group = DispatchGroup()
       
       for id in ids {
           group.enter()
           
           loadSingleData(id: id) { result in
               switch result {
               case .success(let item):
                   loadedItems.append(item)
               case .failure(let error):
                   print("Error loading item \(id): \(error)")
               }
               group.leave()
           }
       }
       
       group.notify(queue: .global(qos: .background)) {
           let sortedItems = ids.compactMap { id in
               loadedItems.first { $0.id == id }
           }
           completion(sortedItems)
       }
   }
    
    func loadSingleData(id: Int, completion: @escaping (Result<DetailScreenModel, Error>) -> Void) {
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
                let trackedItem = try decoder.decode(DetailScreenModel.self, from: data)
                completion(.success(trackedItem))
            } catch {
                print(error)
            }
        }
        
        dataTask.resume()
    }
    
    func loadCollection(type: String, page: Int, completion: @escaping (Result<TrackedItemModel, Error>) -> Void) {
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
                let trackedItem = try decoder.decode(TrackedItemModel.self, from: data)
                completion(.success(trackedItem))
            } catch {
                print(error)
            }
        }
        
        dataTask.resume()
    }

    func loadFilmsByKeyword(keyword: String, page: Int, completion: @escaping (Result<KeyboardResponse, Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "keyword", value: keyword),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Self.apiKey, forHTTPHeaderField: "X-API-KEY")

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in

            if let error {
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {

                if httpResponse.statusCode != 200 {
                    completion(.failure(NetworkError.serverError(statusCode: httpResponse.statusCode)))
                    return
                }
            }

            guard let data else {
                completion(.failure(NetworkError.noData))
                return
            }

            let decoder = JSONDecoder()
            do {
                let film = try decoder.decode(KeyboardResponse.self, from: data)
                completion(.success(film))
            } catch {
                completion(.failure(error))
            }
        }

        dataTask.resume()
    }
}
