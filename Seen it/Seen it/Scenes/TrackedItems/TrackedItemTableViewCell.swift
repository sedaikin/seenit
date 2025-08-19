//
//  TrackedItemTableViewCell.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

import UIKit

final class TrackedItemTableViewCell: UITableViewCell {
    static let reuseID = "TrackedItemTableViewCell"
    
    private let itemName = UILabel()
    private let itemYear = UILabel()
    private let itemDuration = UILabel()
    private let itemImage = UIImageView()
    private let buttonTracked = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    
    private var trackedItem: TrackedItem?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with trackedItem: TrackedItem) {
        self.trackedItem = trackedItem

        itemName.text = trackedItem.itemName
        itemYear.text = trackedItem.itemYear
        itemDuration.text = trackedItem.itemDuration
        itemImage.image = UIImage(systemName: "person.circle")

        buttonTracked.setImage(UIImage(systemName: trackedItem.isTracked ? "bookmark.fill" : "bookmark"), for: .normal)
        accessoryView = buttonTracked
    }
}
