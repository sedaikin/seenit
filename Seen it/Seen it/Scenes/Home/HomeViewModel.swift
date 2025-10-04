//
//  HomeViewModel.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 04.10.2025.
//

import Foundation
import Combine

final class HomeViewModel {
    
    // MARK: - Properties
    
    @Published var films: [FilmItem] = []
    @Published var shows: [FilmItem] = []
    
    // MARK: - Load data
    
    func loadData() {
        
        let loadDataQueue = DispatchQueue(label: "ru.seenit.collection")
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        loadDataQueue.async{
            NetworkManager.shared.loadCollection(type: filmsCollection.topMovies.type, page: 1) { [weak self] result in
                guard let self else { return }
                defer { dispatchGroup.leave() }
                
                switch result {
                case .success(let item):
                    DispatchQueue.main.async {
                        self.films = item.items
                    }
                case .failure(let error):
                    print("Films error:", error)
                }
            }
        }
        
        dispatchGroup.enter()
        loadDataQueue.async{
            NetworkManager.shared.loadCollection(type: filmsCollection.topShows.type, page: 1) { [weak self] result in
                guard let self else { return }
                defer { dispatchGroup.leave() }
                
                switch result {
                case .success(let item):
                    DispatchQueue.main.async {
                        self.shows = item.items
                        
                    }
                case .failure(let error):
                    print("Shows error:", error)
                }
            }
        }
    }
}
