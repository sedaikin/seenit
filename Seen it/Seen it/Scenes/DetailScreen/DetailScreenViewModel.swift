//
//  DetailScreenViewModel.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 28.09.2025.
//

import Foundation
import Combine

final class DetailScreenViewModel {
    
    private let filmId: Int
    private var cancellables = Set<AnyCancellable>()
    
    @Published var detailInfo: DetailScreenModel?
    
    init(filmId: Int) {
        self.filmId = filmId
    }
    
    func loadData() {
        NetworkManager.shared.loadSingleData(id: filmId) { [weak self] result in
            
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    self?.detailInfo = item
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
