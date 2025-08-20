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
    private var trackedItems: [TrackedItem] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "background")
        
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
        title = "Мой список"
        
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)
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
