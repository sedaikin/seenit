//
//  TrackedItemsController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

import UIKit

final class TrackedItemsController: UIViewController, UITableViewDelegate, UITableViewDataSource, TrackedItemDelegate {

    // MARK: - Private properties
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let navigationBar = UINavigationBar()
    private let titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    private lazy var stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    
    private var trackedItems: [FilmItem] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.loadData() { result in
           
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    self.trackedItems.append(contentsOf: item.items)
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        setupTable()
        setupNavbar()
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
    }
    
    private func setupNavbar() {
        titleLabel.text = String(localized: "myList")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white

        subtitleLabel.text = "2 фильма"
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
    
    func didTapButtonInCell(_ cell: TrackedItemTableViewCell, at indexPath: IndexPath) {
        
//        guard var cell = cell.trackedItem else {
//            return
//        }
//        
//        let alertController = UIAlertController(
//            title: String(localized: cell.isTracked ? "markAsNotWatched" : "markAsWatched"),
//            message: String(localized: cell.isTracked ? "movieIsNotWatched" : "movieIsWatched"),
//            preferredStyle: .alert
//        )
//        
//        let okAction = UIAlertAction(title: String(localized: "mark"), style: .default) { _ in
//            cell.isTracked = cell.isTracked == true ? false : true
//            self.tableView.reloadData()
//        }
//        let cancelAction = UIAlertAction(title: String(localized: "cancel"), style: .default, handler: nil)
//        
//        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
    }
}

extension TrackedItemsController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackedItems.count
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
        let singleItemController = SingleItemController(singleItem: singleItem)
        singleItemController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(singleItemController, animated: true)
    }
}
