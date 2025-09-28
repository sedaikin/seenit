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
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let defaults = UserDefaultsKeys()
    private lazy var isTracked = defaults.containsMovieId(id, in: .tracked)
    private lazy var isWatched = defaults.containsMovieId(id, in: .watched)
    var item: SingleTrackedItem?
    
    let id: Int

    // MARK: - Life cycle

    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        loadData()
        setupUI()
        setupCustomBackButton()

        view.backgroundColor = .background
    }
}

// MARK: - Private

private extension SingleItemController {

    func loadData() {
            NetworkManager.shared.loadSingleData(id: id) { result in

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
        view.addSubviews(scrollView,poster,name, year, duration, genresTitle, genres, titleDescription, textDescription, ratingsTitle, ratingKp, ratingImdb, buttonAdded, buttonTracked)
    }

    // MARK: - Setup views
    
//    func setupScrollView() {
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: poster.bottomAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Важно!
//        ])
//    }

    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: poster.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Важно!
        ])
    }

    func setupUI () {

        //setupScrollView()
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
        config.image = UIImage(systemName: isWatched ? "eye.fill" : "eye")
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 8)

        buttonTracked.configuration = config
        buttonTracked.tintColor = isWatched ? .active : .systemGray3
        buttonTracked.contentHorizontalAlignment = .fill
        buttonTracked.contentVerticalAlignment = .fill
        buttonTracked.imageView?.contentMode = .scaleAspectFit
        buttonTracked.addTarget(self, action: #selector(didTapTrackedButton), for: .touchUpInside)
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
        buttonAdded.tintColor = isTracked ? .active : .systemGray3
        let image = isTracked ? "minus.square.fill" : "plus.app"
        buttonAdded.setImage(UIImage(systemName: image), for: .normal)
        buttonAdded.contentHorizontalAlignment = .fill
        buttonAdded.contentVerticalAlignment = .fill
        buttonAdded.imageView?.contentMode = .scaleAspectFit
        buttonAdded.addTarget(self, action: #selector(didTapAddedButton), for: .touchUpInside)
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
    
    @objc func didTapAddedButton() {
        let type = item?.type == "FILM" ? "фильм" : "сериал"
        let title = isTracked ? "Удалить \(type) из списка того, что буду смотреть?" : "Добавить \(type) в список того, что буду смотреть?"
        showAlert(title: title)
    }
    
    @objc func didTapTrackedButton() {
        let type = item?.type == "FILM" ? "фильм" : "сериал"
        let title = isWatched ? "Отметить \(type) как непросмотренный?" : "Отметить \(type) как просмотренный?"
        showAlert(title: title, isAdd: false)
    }
}


// MARK: - Alert

private extension SingleItemController {
    func showAlert(title: String, isAdd: Bool = true) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self else { return }
            if isAdd {
                isTracked ? defaults.removeMovieId(id, from: .tracked) : defaults.addMovieId(id, to: .tracked)
                isTracked ? buttonAdded.setImage(UIImage(systemName: "plus.app"), for: .normal) : buttonAdded.setImage(UIImage(systemName: "minus.square.fill"), for: .normal)
                isTracked = defaults.containsMovieId(id, in: .tracked)
                buttonAdded.tintColor = isTracked ? .active : .systemGray3
            } else {
                isWatched ? defaults.removeMovieId(id, from: .watched) : defaults.addMovieId(id, to: .watched)
                isWatched ? buttonTracked.setImage(UIImage(systemName: "eye"), for: .normal) : buttonTracked.setImage(UIImage(systemName: "eye.fill"), for: .normal)
                isWatched = defaults.containsMovieId(id, in: .watched)
                buttonTracked.tintColor = isWatched ? .active : .systemGray3
            }
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .default))
        present(alert, animated: true)
    }
}
