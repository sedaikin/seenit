//
//  ProfilViewController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let stackView: UIStackView = UIStackView()
    private let submitButton: UIButton = UIButton()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
}
