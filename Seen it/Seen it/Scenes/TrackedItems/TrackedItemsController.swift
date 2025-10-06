//
//  TrackedItemsController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

import UIKit
import Combine

final class TrackedItemsController: BaseViewController {

    // MARK: - Private properties
    
    private let tableView = UITableView()
    private let defaults = UserDefaultsKeys()
    private lazy var filmIds = defaults.getMovieIds(for: .tracked)
    private lazy var viewModel = TrackedItemsViewModel(filmIds: filmIds)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
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
        
        tableView.frame = view.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackedItemTableViewCell.self, forCellReuseIdentifier: TrackedItemTableViewCell.reuseID)
        tableView.backgroundColor = .background
        tableView.contentInset.top = 16
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tableView.separatorColor = .systemGray3
        tableView.tableHeaderView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        
        view.addSubview(tableView)
    }
    
    private func setupNavbar() {
        title = "";
        navigationItem.title = NSLocalizedString("myList", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
}

// MARK: - UITableViewDelegate

extension TrackedItemsController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension TrackedItemsController: UITableViewDataSource {
    
}

// MARK: - TrackedItemDelegate

extension TrackedItemsController: TrackedItemDelegate {
    
    // MARK: - Actions
    
    func didTapButtonInCell(_ cell: TrackedItemTableViewCell, at indexPath: IndexPath) {
        let isWatched = defaults.containsMovieId(viewModel.films[indexPath.row].id, in: .watched)
        showAlert(title: "Отметить как " + (isWatched ? "непросмотренный" : "просмотренный?"), indexPath: indexPath)
    }
    
}

extension TrackedItemsController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackedItemTableViewCell.reuseID, for: indexPath) as? TrackedItemTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.configure(with: viewModel.films[indexPath.row])
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .tabbar
        cell.selectedBackgroundView = backgroundView

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let singleItem = viewModel.films[indexPath.row]
        let singleItemController = DetailScreenViewController(id: singleItem.id)
        singleItemController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(singleItemController, animated: true)
    }
}

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
    
    func showAlert(title: String, isAdd: Bool = true, indexPath: IndexPath) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self else { return }
            let isWatched = defaults.containsMovieId(viewModel.films[indexPath.row].id, in: .watched)
            isWatched ? defaults.removeMovieId(viewModel.films[indexPath.row].id, from: .watched) :
                        defaults.addMovieId(viewModel.films[indexPath.row].id, to: .watched)
            tableView.reloadData()
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .default))
        present(alert, animated: true)
    }
    
}

private extension TrackedItemsController {
        
    func setupBinding() {
        viewModel.$films
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
}
