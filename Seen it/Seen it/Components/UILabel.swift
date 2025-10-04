//
//  UILabel.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 29.09.2025.
//

import UIKit

extension UILabel {
    func configBigText(_ color: UIColor) {
        font = .systemFont(ofSize: 16, weight: .bold)
        textColor = color
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configSmallText(_ with: String = "") {
        text = String(localized: "\(with)")
        textColor = .systemGray3
        font = .boldSystemFont(ofSize: 12)
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
    }
    
    func configTitle(_ with: String = "") {
        text = NSLocalizedString(with, comment: "")
        font = .boldSystemFont(ofSize: 14)
        textColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }
}
