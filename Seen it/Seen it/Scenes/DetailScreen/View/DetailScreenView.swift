//
//  DetailScreenView.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 28.09.2025.
//

import UIKit

protocol DetailScreenDelegate: AnyObject {
    func tapTrackedButton()
    func tapAddedButton()
}

final class DetailScreenView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: DetailScreenDelegate?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView ()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let poster: RemoteImageView = {
        let imageView = RemoteImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonTracked: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "eye")
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 8)
        button.configuration = config
        button.tintColor = .systemGray3
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapTrackedButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let buttonAdded: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray3
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapAddedButton), for: .touchUpInside)
        return button
    }()
    
    private let year: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let duration: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genresTitle: UILabel = {
        let label = UILabel()
        label.configTitle("genres")
        return label
    }()
    
    private let genres: UILabel = {
        let label = UILabel()
        label.configSmallText()
        return label
    }()
    
    private let titleDescription: UILabel = {
        let label = UILabel()
        label.configTitle("description")
        return label
    }()
    
    private let textDescription: UILabel = {
        let label = UILabel()
        label.configSmallText()
        return label
    }()
    
    private let ratingsTitle: UILabel = {
        let label = UILabel()
        label.configTitle("rating")
        return label
    }()
    
    private let ratingKp: UILabel = {
        let label = UILabel()
        label.configSmallText()
        return label
    }()
    
    private let ratingImdb: UILabel = {
        let label = UILabel()
        label.configSmallText()
        return label
    }()
    
    // MARK: - Lify cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            poster,
            name,
            buttonTracked,
            buttonAdded,
            year,
            duration,
            genresTitle,
            genres,
            titleDescription,
            textDescription,
            ratingsTitle,
            ratingKp,
            ratingImdb
        )
    }
    
    // MARK: - Setup layout
    
    func setupLayout() {
        let contentViewHeightAnchor = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: trailingAnchor),
            topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: bottomAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            poster.topAnchor.constraint(equalTo: contentView.topAnchor),
            poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            poster.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            poster.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            
            name.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 16),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            name.trailingAnchor.constraint(equalTo: buttonTracked.leadingAnchor),
            
            buttonTracked.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 16),
            buttonTracked.leadingAnchor.constraint(equalTo: name.trailingAnchor, constant: 0),
            buttonTracked.trailingAnchor.constraint(equalTo: buttonAdded.leadingAnchor, constant: 0),
            buttonTracked.widthAnchor.constraint(equalToConstant: 42),
            buttonTracked.heightAnchor.constraint(equalToConstant: 32),
            
            buttonAdded.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 16),
            buttonAdded.leadingAnchor.constraint(equalTo: buttonTracked.trailingAnchor, constant: 0),
            buttonAdded.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            buttonAdded.widthAnchor.constraint(equalToConstant: 26),
            buttonAdded.heightAnchor.constraint(equalToConstant: 32),
            
            year.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            year.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            year.trailingAnchor.constraint(equalTo: duration.leadingAnchor, constant: 0),
            
            duration.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            duration.leadingAnchor.constraint(equalTo: year.trailingAnchor, constant: 0),
            duration.trailingAnchor.constraint(equalTo: buttonTracked.leadingAnchor, constant: 0),
            
            genresTitle.topAnchor.constraint(equalTo: year.bottomAnchor, constant: 28),
            genresTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            genresTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            genres.topAnchor.constraint(equalTo: genresTitle.bottomAnchor, constant: 6),
            genres.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            genres.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            titleDescription.topAnchor.constraint(equalTo: genres.bottomAnchor, constant: 28),
            titleDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            textDescription.topAnchor.constraint(equalTo: titleDescription.bottomAnchor, constant: 6),
            textDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            textDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            ratingsTitle.topAnchor.constraint(equalTo: textDescription.bottomAnchor, constant: 28),
            ratingsTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            ratingsTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            ratingKp.topAnchor.constraint(equalTo: ratingsTitle.bottomAnchor, constant: 6),
            ratingKp.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            ratingKp.trailingAnchor.constraint(equalTo: ratingImdb.leadingAnchor, constant: 0),
            
            ratingImdb.topAnchor.constraint(equalTo: ratingsTitle.bottomAnchor, constant: 6),
            ratingImdb.leadingAnchor.constraint(equalTo: ratingKp.trailingAnchor, constant: 0),
            ratingImdb.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
        ])
        
        contentViewHeightAnchor.priority = .defaultLow
        contentViewHeightAnchor.isActive = true
    }
    
    // MARK: - Update UI funcs
    
    func updateUI(_ viewModel: DetailScreenViewModel) {
        guard let detailInfo = viewModel.detailInfo,
              let url = URL(string: detailInfo.image) else {
            return
        }
        
        poster.setImage(url: url)
        
        name.text = detailInfo.name
        year.text = String(detailInfo.year)
        textDescription.text = detailInfo.description
        genres.text = detailInfo.genres.map { $0.genre }.joined(separator: ", ")
        
        guard let ratingKinopoisk = detailInfo.ratingKinopoisk else {
            ratingKp.text = String(localized: "noRating")
            return
        }
        
        ratingKp.text = "Кинопоиск: " + String(ratingKinopoisk)
    
        guard let ratingImdbUnwrapped = detailInfo.ratingImdb else {
            return
        }
        
        ratingImdb.text = " | IMDB: " + String(ratingImdbUnwrapped)
        
        if let allDuration = detailInfo.duration {
            let hours = String(allDuration/60)
            let minutes = String(allDuration%60)
            
            duration.text = " \u{2022} " + (hours != "0" ? hours + " \(String(localized: "hours")) " : "") + minutes + " \(String(localized: "mins"))"
        }
    }
    
    func updateWatchedButton(_ isWatched: Bool) {
        buttonTracked.tintColor = isWatched ? .active : .systemGray3
        isWatched ? buttonTracked.setImage(UIImage(systemName: "eye.fill"), for: .normal) :
        buttonTracked.setImage(UIImage(systemName: "eye"), for: .normal)
    }
    
    func updateAddedButton(_ isTracked: Bool) {
        buttonAdded.tintColor = isTracked ? .active : .systemGray3
        isTracked ? buttonAdded.setImage(UIImage(systemName: "bookmark.fill"), for: .normal) :
                    buttonAdded.setImage(UIImage(systemName: "bookmark"), for: .normal)
    }
}

private extension DetailScreenView {
    
    // MARK: - Actions
    
    @objc func didTapTrackedButton(_ sender: UIButton) {
        delegate?.tapTrackedButton()
    }
    
    @objc func didTapAddedButton(_ sender: UIButton) {
        delegate?.tapAddedButton()
    }
}
