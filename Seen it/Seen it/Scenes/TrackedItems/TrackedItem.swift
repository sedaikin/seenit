//
//  TrackedItem.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

final class TrackedItem {
    let itemName: String
    let itemYear: String
    let itemDuration: String
    let itemImage: String
    var isTracked = false


    init(itemName: String, itemYear: String, itemDuration: String, itemImage: String, isTracked: Bool = false) {
        self.itemName = itemName
        self.itemYear = itemYear
        self.itemDuration = itemDuration
        self.itemImage = itemImage
        self.isTracked = isTracked
    }
}
