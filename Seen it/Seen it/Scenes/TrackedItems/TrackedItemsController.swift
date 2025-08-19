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
}
