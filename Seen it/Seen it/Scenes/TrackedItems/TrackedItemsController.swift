//
//  TrackedItemsController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

import UIKit
import Combine

final class TrackedItemsController: UIViewController {

    // MARK: - Private properties
    
    private let defaults = UserDefaultsKeys()
    private lazy var filmIds = defaults.getMovieIds(for: .tracked)
    private lazy var viewModel = TrackedItemsViewModel(filmIds: filmIds)
    private let tableManager = TrackedItemsListTableManager()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableManager.delegate = self
        setupNavbar()
        setupNotifications()
        setupBinding()
        viewModel.loadInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshAllData(defaults.getMovieIds(for: .tracked))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableManager.tableView.frame = view.bounds
    }
    
    override func loadView() {
        view = tableManager
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup
    
    private func setupNavbar() {
        title = "";
        navigationItem.title = NSLocalizedString("myList", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
}

// MARK: - Setup notification center

private extension TrackedItemsController {
    
    func setupNotifications() {
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .receive(on: RunLoop.main)
            .sink{ [weak self] _ in
                guard let items = self?.defaults.getMovieIds(for: .tracked) else {
                    return
                }
                self?.viewModel.refreshAllData(items)
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - Setup bindings for viewModel

private extension TrackedItemsController {
        
    func setupBinding() {
        viewModel.$films
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let films = self?.viewModel.films else {
                    return
                }
                self?.tableManager.films = films
                self?.tableManager.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - Navigation delegate

extension TrackedItemsController: NavigationDelegate {

    func navigateToNewScreen(to: UIViewController) {
        navigationController?.pushViewController(to, animated: true)
    }
    
    func presentFor(alert: UIAlertController) {
        present(alert, animated: true)
    }
    
}
