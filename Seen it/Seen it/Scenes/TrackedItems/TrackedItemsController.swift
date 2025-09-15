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
    private let refreshControl = UIRefreshControl()
    private let navigationBar = UINavigationBar()
    private let titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    private lazy var stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    private let defautls = UserDefaultsKeys()
    private lazy var filmsCount = defaults.getMovieIds(for: .watched).count
    
    private var trackedItems: [SingleTrackedItem] = []
    private let defaults = UserDefaultsKeys()
    private lazy var addedItems = defaults.getMovieIds(for: .tracked)
    
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupNavbar()
        //loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }

    // MARK: - Setup
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackedItemTableViewCell.self, forCellReuseIdentifier: TrackedItemTableViewCell.reuseID)
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = .background
        tableView.contentInset.top = 16
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tableView.separatorColor = .systemGray3
        tableView.tableHeaderView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        
    }
    
    private func setupNavbar() {
        titleLabel.text = String(localized: "myList")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .systemGray3

        stackView.axis = .vertical
        stackView.alignment = .center
        
        view.addSubview(tableView)
        view.addSubview(navigationBar)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background
        
        navigationItem.titleView = stackView
        navigationController?.additionalSafeAreaInsets.top = 5
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    // MARK: - Actions
    
    @objc func refreshData(_ sender: UIRefreshControl) {
        refreshData()
    }
    
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
    
    func loadData() {
        for addedItem in addedItems {
            NetworkManager.shared.loadSingleData(id: addedItem) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let item):
                    DispatchQueue.main.async {
                        self.trackedItems.append(item)
                        self.tableView.reloadData()
                        self.filmsCount = self.trackedItems.count
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func refreshData() {
        trackedItems = []
        addedItems = defaults.getMovieIds(for: .tracked)
        loadData()
        subtitleLabel.text = "Вы хотите посмотреть \(filmsCount) фильмов/сериалов"
        tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func showAlert(title: String, isAdd: Bool = true, indexPath: IndexPath) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self else { return }
            let isWatched = defaults.containsMovieId(trackedItems[indexPath.row].id, in: .watched)
            isWatched ? defaults.removeMovieId(trackedItems[indexPath.row].id, from: .watched) : defautls.addMovieId(trackedItems[indexPath.row].id, to: .watched)
            tableView.reloadData()
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .default))
        present(alert, animated: true)
    }
    
}
