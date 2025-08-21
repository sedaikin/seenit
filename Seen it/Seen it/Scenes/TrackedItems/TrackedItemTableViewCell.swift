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
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let labelWidth = contentView.bounds.width - Constants.horizontal - Constants.Avatar.size.width - Constants.Name.left - Constants.horizontal
        
        itemName.frame = CGRect(
            x: Constants.horizontal + Constants.Avatar.size.width + Constants.Name.left,
            y: Constants.Name.top,
            width: labelWidth,
            height: Constants.Name.height
        )

        itemYear.frame = CGRect(
            x: Constants.horizontal + Constants.Avatar.size.width + Constants.Name.left,
            y: Constants.Name.top + Constants.Name.height + Constants.Phone.top,
            width: labelWidth,
            height: Constants.Phone.height
        )
    }
    
    private func setup() {
        itemName.font = .systemFont(ofSize: 16, weight: .bold)
        itemName.textColor = .white
        itemYear.font = .systemFont(ofSize: 12, weight: .light)
        itemYear.textColor = .white
        itemDuration.font = .systemFont(ofSize: 15, weight: .regular)

        contentView.addSubview(itemName)
        contentView.addSubview(itemYear)
        contentView.addSubview(itemDuration)
        self.backgroundColor = UIColor(named: "background")
    }
    
    func configure(with trackedItem: TrackedItem) {
        self.trackedItem = trackedItem

        itemName.text = trackedItem.itemName
        itemYear.text = trackedItem.itemYear
        itemDuration.text = trackedItem.itemDuration
        itemImage.image = UIImage(systemName: "person.circle")

        buttonTracked.setImage(UIImage(systemName: trackedItem.isTracked ? "eye.fill" : "eye"), for: .normal)
        accessoryView = buttonTracked
    }
}

private extension TrackedItemTableViewCell {
    struct Constants {
        struct Avatar {
            static let size = CGSize(width: 40, height: 40)
            static let vertical: CGFloat = 12
        }

        struct Name {
            static let top: CGFloat = 8
            static let left: CGFloat = 8
            static let height: CGFloat = 24
        }

        struct Phone {
            static let top: CGFloat = 1
            static let left: CGFloat = 8
            static let height: CGFloat = 20
        }

        static let horizontal: CGFloat = 16
    }
}
