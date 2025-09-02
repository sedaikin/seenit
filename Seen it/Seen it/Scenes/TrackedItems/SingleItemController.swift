//
//  SingleItemController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 25.08.2025.
//

import UIKit

class SingleItemController: UIViewController {
    
    let singleItem: FilmItem

    init(singleItem: FilmItem) {
        self.singleItem = singleItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = singleItem.name
        view.backgroundColor = .background
        
        setup()
    }
    
    private func setup () {
        
    }
}
