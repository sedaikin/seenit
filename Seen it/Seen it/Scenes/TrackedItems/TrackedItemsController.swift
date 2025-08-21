//
//  TrackedItemsController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

import UIKit

final class TrackedItemsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Private properties
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let navigationBar = UINavigationBar()
    
    private var trackedItems: [TrackedItem] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        loadData()
    }
 
    
    func loadData() {
        self.trackedItems = generateData()
        self.tableView.reloadData()
    }
    
    func generateData() -> [TrackedItem] {
        return [
            TrackedItem(itemName: "Изгой", itemYear: "2006", itemDuration: "1:34", itemImage: ""),
            TrackedItem(itemName: "Один дома 1", itemYear: "1999", itemDuration: "1:44", itemImage: "")
        ]
    }
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackedItemTableViewCell.self, forCellReuseIdentifier: TrackedItemTableViewCell.reuseID)
        tableView.refreshControl = refreshControl
        tableView.frame = view.bounds
        tableView.backgroundColor = UIColor(named: "background")
        tableView.contentInset.top = 45
        
        let titleLabel = UILabel()
        titleLabel.text = "Мой список"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white

        let subtitleLabel = UILabel()
        subtitleLabel.text = "2 фильма"
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .systemGray3

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center

        navigationItem.titleView = stackView
        navigationController?.additionalSafeAreaInsets.top = 5
        
        view.addSubview(tableView)
        view.addSubview(navigationBar)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}


extension TrackedItemsController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackedItemTableViewCell.reuseID, for: indexPath) as? TrackedItemTableViewCell else {
            return .init()
        }

        cell.configure(with: trackedItems[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
