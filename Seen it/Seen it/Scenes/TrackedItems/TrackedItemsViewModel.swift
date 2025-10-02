//
//  TrackedItemsViewModel.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 01.10.2025.
//

import Foundation
import Combine

final class TrackedItemsViewModel {
    
    private var filmIds: [Int] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var films: [DetailScreenModel] = []
    
    init(filmIds: [Int]) {
        self.filmIds = filmIds
    }
    
    func loadInitialData() {
        NetworkManager.shared.loadDataForIds(filmIds) { [weak self] loadedItems in
            DispatchQueue.main.async {
                self?.films = loadedItems
            }
        }
    }
    
    func refreshAllData(_ newItemIds: [Int]) {
        
        guard !newItemIds.isEmpty else {
            films.removeAll()
            return
        }

        NetworkManager.shared.loadDataForIds(newItemIds) { [weak self] loadedItems in
            DispatchQueue.main.async {
                self?.films = loadedItems
            }
        }
    } 
}
