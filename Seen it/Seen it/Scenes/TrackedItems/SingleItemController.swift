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
    private let ratingsTitle = UILabel()
    private let ratingKp = UILabel()
    private let ratingImdb = UILabel()
    private let genresTitle = UILabel()
    private let genres = UILabel()
    private let buttonTracked = UIButton()
    private let buttonAdded = UIButton()
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
        addSubViews()
        loadData()
        setupUI()
        setupCustomBackButton()
        
        view.backgroundColor = .background
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restoreDefaultNavBar()
    }
}

// MARK: - Private

private extension SingleItemController {
    
    func loadData() {
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
    }
    
    // MARK: - Add subViews
    
    func addSubViews() {
        view.addSubviews(poster, name, year, duration, genresTitle, genres, titleDescription, textDescription, ratingsTitle, ratingKp, ratingImdb, buttonAdded, buttonTracked)
    }
    
    // MARK: - Setup views
    
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
        setupPoster()
        setupName()
        setupButtonTracked()
        setupButtonAdded()
        setupYear()
        setupDuration()
        setupGenresTitle()
        setupGenres()
        setupTitleDescription()
        setupTextDescription()
        setupRatingsTitle()
        setupRatingKp()
        setupRatingIMDB()
    }
    
    func setupPoster() {
        poster.contentMode = .scaleAspectFill
        poster.clipsToBounds = true
        
        poster.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo:view.topAnchor, constant: 0),
            poster.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            poster.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            poster.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)
        ])
    }
    
    func setupName() {
        name.font = .boldSystemFont(ofSize: 24)
        name.textColor = .white
        name.numberOfLines = 0
        
        name.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 16),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            name.trailingAnchor.constraint(equalTo: buttonTracked.leadingAnchor, constant: 0)
        ])
    }
    
    func setupButtonTracked() {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "eye")
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)

        buttonTracked.configuration = config
        buttonTracked.tintColor = .active
        buttonTracked.contentHorizontalAlignment = .fill
        buttonTracked.contentVerticalAlignment = .fill
        buttonTracked.imageView?.contentMode = .scaleAspectFit
        
        buttonTracked.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonTracked.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 16),
            buttonTracked.leadingAnchor.constraint(equalTo: name.trailingAnchor, constant: 0),
            buttonTracked.trailingAnchor.constraint(equalTo: buttonAdded.leadingAnchor, constant: 0),
            buttonTracked.widthAnchor.constraint(equalToConstant: 42),
            buttonTracked.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func setupButtonAdded() {
        buttonAdded.tintColor = .active
        buttonAdded.setImage(UIImage(systemName: "plus.app"), for: .normal)
        buttonAdded.contentHorizontalAlignment = .fill
        buttonAdded.contentVerticalAlignment = .fill
        buttonAdded.imageView?.contentMode = .scaleAspectFit
        
        buttonAdded.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonAdded.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 16),
            buttonAdded.leadingAnchor.constraint(equalTo: buttonTracked.trailingAnchor, constant: 0),
            buttonAdded.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            buttonAdded.widthAnchor.constraint(equalToConstant: 26),
            buttonAdded.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func setupYear() {
        year.font = .boldSystemFont(ofSize: 16)
        year.textColor = .systemGray2
        
        year.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            year.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            year.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            year.trailingAnchor.constraint(equalTo: duration.leadingAnchor, constant: 0)
        ])
    }
    
    func setupDuration() {
        duration.font = .boldSystemFont(ofSize: 16)
        duration.textColor = .systemGray2
        
        duration.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            duration.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            duration.leadingAnchor.constraint(equalTo: year.trailingAnchor, constant: 0),
            duration.trailingAnchor.constraint(equalTo: buttonTracked.leadingAnchor, constant: 0)
        ])
    }
    
    func setupGenresTitle() {
        genresTitle.text = String(localized: "genres")
        genresTitle.font = .boldSystemFont(ofSize: 14)
        genresTitle.textColor = .white
        
        genresTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genresTitle.topAnchor.constraint(equalTo: year.bottomAnchor, constant: 28),
            genresTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            genresTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    func setupGenres() {
        genres.font = .systemFont(ofSize: 12)
        genres.textColor = .systemGray3
        genres.numberOfLines = 0
        
        genres.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genres.topAnchor.constraint(equalTo: genresTitle.bottomAnchor, constant: 6),
            genres.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            genres.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
    
    func setupTitleDescription() {
        titleDescription.text = String(localized: "description")
        titleDescription.font = .boldSystemFont(ofSize: 14)
        titleDescription.textColor = .white
        
        titleDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleDescription.topAnchor.constraint(equalTo: genres.bottomAnchor, constant: 28),
            titleDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    func setupTextDescription() {
        textDescription.font = .systemFont(ofSize: 12)
        textDescription.textColor = .systemGray3
        textDescription.numberOfLines = 0
        
        textDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textDescription.topAnchor.constraint(equalTo: titleDescription.bottomAnchor, constant: 6),
            textDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
    
    func setupRatingsTitle() {
        ratingsTitle.text = String(localized: "rating")
        ratingsTitle.textColor = .white
        ratingsTitle.font = .boldSystemFont(ofSize: 14)
        
        ratingsTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingsTitle.topAnchor.constraint(equalTo: textDescription.bottomAnchor, constant: 28),
            ratingsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            ratingsTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
    
    func setupRatingKp() {
        ratingKp.font = .systemFont(ofSize: 12)
        ratingKp.textColor = .systemGray3
        
        ratingKp.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingKp.topAnchor.constraint(equalTo: ratingsTitle.bottomAnchor, constant: 6),
            ratingKp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            ratingKp.trailingAnchor.constraint(equalTo: ratingImdb.leadingAnchor, constant: 0),
        ])
    }
    
    func setupRatingIMDB() {
        ratingImdb.font = .systemFont(ofSize: 12)
        ratingImdb.textColor = .systemGray3
        
        ratingImdb.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingImdb.topAnchor.constraint(equalTo: ratingsTitle.bottomAnchor, constant: 6),
            ratingImdb.leadingAnchor.constraint(equalTo: ratingKp.trailingAnchor, constant: 0),
            ratingImdb.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
    
    func setupCustomBackButton() {
        var config = UIButton.Configuration.plain()
        
        config.image = UIImage(systemName: "arrow.left")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        
        let backButton = UIButton(configuration: config)
        backButton.tintColor = .white
        
        backButton.backgroundColor = .active
        backButton.layer.cornerRadius = 15
        backButton.layer.masksToBounds = true
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    // MARK: - Update UI
    
    func updateUI() {
        guard let item, let url = URL(string: item.image) else {
            return
        }
        
        poster.setImage(url: url)
        
        name.text = item.name
        year.text = String(item.year)
        textDescription.text = item.description
        genres.text = item.genres.map { $0.genre }.joined(separator: ", ")
        
        guard let ratingKinopoisk = item.ratingKinopoisk else {
            ratingKp.text = String(localized: "noRating")
            return
        }
        
        ratingKp.text = "Кинопоиск: " + String(ratingKinopoisk)
    
        guard let ratingImdbUnwrapped = item.ratingImdb else {
            return
        }
        
        ratingImdb.text = " | IMDB: " + String(ratingImdbUnwrapped)
        
        if let allDuration = item.duration {
            let hours = String(allDuration/60)
            let minutes = String(allDuration%60)
            
            duration.text = " \u{2022} " + (hours != "0" ? hours + " \(String(localized: "hours")) " : "") + minutes + " \(String(localized: "mins"))"
        }
    }
    
}

// MARK: - Actions

private extension SingleItemController {
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
