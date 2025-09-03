//
//  SingleItemController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 25.08.2025.
//

import UIKit

final class SingleItemController: UIViewController {
    
    // MARK: - Properties
    
    private let name = UILabel()
    private let textDescription = UILabel()
    private let year = UILabel()
    private let duration = UILabel()
    private let titleDescription = UILabel()
    private let poster = RemoteImageView()
    var item: SingleTrackedItem?
    
    let singleItem: FilmItem
    
    // MARK: - Life cycle

    init(singleItem: FilmItem) {
        self.singleItem = singleItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTransparentNavBar()
        
        NetworkManager.shared.loadSingleData(id: singleItem.id) { result in
           
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    self.item = item
                    self.updateUI()
                }
            case .failure(let error):
                print(error)
            }
        }

        view.backgroundColor = .background
  
        
        view.addSubview(poster)
        view.addSubview(name)
        view.addSubview(year)
        view.addSubview(duration)
        view.addSubview(titleDescription)
        view.addSubview(textDescription)
        
        setupUI()
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restoreDefaultNavBar()
    }
}

// MARK: - Private

private extension SingleItemController {
    
    func setupTransparentNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
    }
    
    func restoreDefaultNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    func setupUI () {
        poster.contentMode = .scaleAspectFill
        poster.clipsToBounds = true
        
        name.font = .boldSystemFont(ofSize: 24)
        name.textColor = .white
        name.numberOfLines = 0
        
        year.font = .boldSystemFont(ofSize: 16)
        year.textColor = .systemGray2
        
        duration.font = .boldSystemFont(ofSize: 16)
        duration.textColor = .systemGray2
        
        titleDescription.text = String(localized: "description")
        titleDescription.font = .boldSystemFont(ofSize: 14)
        titleDescription.textColor = .white
        
        textDescription.font = .systemFont(ofSize: 12)
        textDescription.textColor = .systemGray3
        textDescription.numberOfLines = 0
    }
    
    func setupLayout() {
        poster.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo:view.topAnchor, constant: 0),
            poster.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            poster.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            poster.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)
        ])
        
        name.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 16),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        year.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            year.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            year.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            year.trailingAnchor.constraint(equalTo: duration.leadingAnchor, constant: 0)
        ])
        
        duration.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            duration.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            duration.leadingAnchor.constraint(equalTo: year.trailingAnchor, constant: 0),
            duration.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        titleDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleDescription.topAnchor.constraint(equalTo: year.bottomAnchor, constant: 28),
            titleDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        textDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textDescription.topAnchor.constraint(equalTo: titleDescription.bottomAnchor, constant: 6),
            textDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
    
    func updateUI() {
        guard let item = item, let url = URL(string: item.image) else {
            return
        }
        
        poster.setImage(url: url)
        
        name.text = item.name
        year.text = String(item.year)
        textDescription.text = item.description
        
        if let allDuration = item.duration {
            let hours = String(allDuration/60)
            let minutes = String(allDuration%60)
            
            duration.text = " \u{2022} " + (hours != "0" ? hours + " \(String(localized: "hours")) " : "") + minutes + " \(String(localized: "mins"))"
        }
    }
    
}
