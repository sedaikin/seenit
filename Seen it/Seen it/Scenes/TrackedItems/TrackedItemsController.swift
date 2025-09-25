//
//  TrackedItemsController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

import UIKit

final class TrackedItemsController: UIViewController {

    // MARK: - Private properties
    
    private let tableView = UITableView()
    private let defaults = UserDefaultsKeys()
    private lazy var filmsCount = defaults.getMovieIds(for: .watched).count
    
    private var trackedItems: [SingleTrackedItem] = []
    private lazy var addedItems = defaults.getMovieIds(for: .tracked)
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupNavbar()
        setupNotifications()
        loadInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshAllData()
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
        title = String(localized: "myList")
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    // MARK: - Actions
    
    func didTapButtonInCell(_ cell: TrackedItemTableViewCell, at indexPath: IndexPath) {
        let isWatched = defaults.containsMovieId(trackedItems[indexPath.row].id, in: .watched)
        showAlert(title: "Отметить как " + (isWatched ? "непросмотренный" : "просмотренный?"), indexPath: indexPath)
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
    
}

extension TrackedItemsController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackedItemTableViewCell.reuseID, for: indexPath) as? TrackedItemTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.configure(with: trackedItems[indexPath.row])
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .tabbar
        cell.selectedBackgroundView = backgroundView

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let singleItem = trackedItems[indexPath.row]
        let singleItemController = SingleItemController(id: singleItem.id)
        singleItemController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(singleItemController, animated: true)
    }
}

private extension TrackedItemsController {
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDefaultsDidChange),
            name: UserDefaults.didChangeNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshWhenAppearing),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    func loadInitialData() {
        NetworkManager.shared.loadDataForIds(addedItems) { [weak self] loadedItems in
            DispatchQueue.main.async {
                self?.trackedItems = loadedItems
                self?.tableView.reloadData()
            }
        }
    }
    
    func refreshAllData() {
        let newItemIds = defaults.getMovieIds(for: .tracked)
        
        guard !newItemIds.isEmpty else {
            addedItems.removeAll()
            tableView.reloadData()
            return
        }
        
        NetworkManager.shared.loadDataForIds(newItemIds) { [weak self] loadedItems in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.trackedItems = loadedItems
                self.tableView.reloadData()
            }
        }
    }
    
    func showAlert(title: String, isAdd: Bool = true, indexPath: IndexPath) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self else { return }
            let isWatched = defaults.containsMovieId(trackedItems[indexPath.row].id, in: .watched)
            isWatched ? defaults.removeMovieId(trackedItems[indexPath.row].id, from: .watched) : defaults.addMovieId(trackedItems[indexPath.row].id, to: .watched)
            tableView.reloadData()
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .default))
        present(alert, animated: true)
    }
    
}

private extension TrackedItemsController {
    
    // MARK: -Objc funcs
    
    @objc private func userDefaultsDidChange(_ notification: Notification) {
        
       let newIds = defaults.getMovieIds(for: .tracked)
       let currentIds = addedItems.map { $0 }
       
       if newIds != currentIds {
       DispatchQueue.main.async {
               self.refreshAllData()
           }
       }
    }
    
    @objc private func refreshWhenAppearing() {
        refreshAllData()
    }
    
}
