//
//  TrackedItemsController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 05.10.2025.
//

import UIKit

// MARK: - Delegate for navigation and alert

protocol NavigationDelegate: AnyObject {
    func navigateToNewScreen(to: UIViewController)
    func presentFor(alert: UIAlertController)
}

final class TrackedItemsListTableManager: UIView, UITableViewDataSource {
    
    // MARK: - Properties
    
    weak var delegate: NavigationDelegate?
    var films: [DetailScreenModel] = []
    let tableView = UITableView()
    private let defaults = UserDefaultsKeys()
    private lazy var filmIds = defaults.getMovieIds(for: .tracked)
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTable()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup tableView
    
    private func setupTable() {
        self.translatesAutoresizingMaskIntoConstraints = false
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
        
        addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let singleItem = films[indexPath.row]
        let singleItemController = DetailScreenViewController(id: singleItem.id)
        singleItemController.hidesBottomBarWhenPushed = true
        delegate?.navigateToNewScreen(to: singleItemController)
    }
    
}

// MARK: - UITableViewDelegate

extension TrackedItemsListTableManager: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackedItemTableViewCell.reuseID, for: indexPath) as? TrackedItemTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.configure(with: films[indexPath.row])
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .tabbar
        cell.selectedBackgroundView = backgroundView

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        films.count
    }
    
}

// MARK: - TrackedItemDelegate

extension TrackedItemsListTableManager: TrackedItemDelegate {
    
    func didTapButtonInCell(_ cell: TrackedItemTableViewCell, at indexPath: IndexPath) {
        let isWatched = defaults.containsMovieId(films[indexPath.row].id, in: .watched)
        showAlert(title: "Отметить как " + (isWatched ? "непросмотренный" : "просмотренный?"), indexPath: indexPath)
    }
    
    func showAlert(title: String, isAdd: Bool = true, indexPath: IndexPath) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self else { return }
            let isWatched = defaults.containsMovieId(films[indexPath.row].id, in: .watched)
            isWatched ? defaults.removeMovieId(films[indexPath.row].id, from: .watched) :
                        defaults.addMovieId(films[indexPath.row].id, to: .watched)
            tableView.reloadData()
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .default))
        delegate?.presentFor(alert: alert)
    }
}
