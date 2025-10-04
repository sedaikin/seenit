//
//  HomeViewController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var viewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let collectionView = HomeViewCollection()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        setupBinding()
        viewModel.loadData()
    }
    
    override func loadView() {
        view = collectionView
    }

}

// MARK: - Private

private extension HomeViewController {
    
    static func getCurrentYear() -> String {
        String(Calendar.current.component(.year, from: Date()))
    }
    
    func setupBinding() {
        viewModel.$films
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let films = self?.viewModel.films else {
                    return
                }
                self?.collectionView.sections[0].items = films
            }
            .store(in: &cancellables)
        
        viewModel.$shows
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let shows = self?.viewModel.shows else {
                    return
                }
                self?.collectionView.sections[1].items = shows
                self?.collectionView.applySnapshot()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Navigation delegate

extension HomeViewController: NavigationDelegate {
    func navigateToNewScreen(to: UIViewController) {
        navigationController?.pushViewController(to, animated: true)
    }
}
