//
//  UIView.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 04.09.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach{ addSubview($0) }
    }
}
