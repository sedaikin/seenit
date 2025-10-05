//
//  SearchResultCell.swift
//  Seen it
//
//  Created by Rogova Mariya on 28.09.2025.
//

import UIKit

import UIKit

final class SearchResultCell: UITableViewCell {

    static let reuseID = "SearchResultCell"

    // MARK: - Properties
    private let filmImageView: RemoteImageView = {
        let imageView = RemoteImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()

    private let englishTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        return label
    }()

    private let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 2
        return label
    }()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor(named: "background")
        selectionStyle = .none

        contentView.addSubview(filmImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(englishTitleLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(detailsLabel)

        NSLayoutConstraint.activate([
            filmImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            filmImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            filmImageView.widthAnchor.constraint(equalToConstant: 60),
            filmImageView.heightAnchor.constraint(equalToConstant: 90),

            titleLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),

            englishTitleLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 12),
            englishTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),

            yearLabel.leadingAnchor.constraint(equalTo: englishTitleLabel.trailingAnchor, constant: 8),
            yearLabel.centerYAnchor.constraint(equalTo: englishTitleLabel.centerYAnchor),

            detailsLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 12),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            detailsLabel.topAnchor.constraint(equalTo: englishTitleLabel.bottomAnchor, constant: 4),
            detailsLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Configuration
    func configure(with film: Film) {
        let russianName = film.nameRu
        let englishName = film.nameEn
        let year = film.year ?? "год не указан"

        if let russianName = russianName, !russianName.isEmpty {
            titleLabel.text = russianName
            if let englishName = englishName, !englishName.isEmpty, englishName != russianName {
                englishTitleLabel.text = englishName
                yearLabel.text = "• \(year)"
            } else {
                englishTitleLabel.text = year
                yearLabel.text = nil
            }
        } else if let englishName = englishName, !englishName.isEmpty {
            titleLabel.text = englishName
            englishTitleLabel.text = year
            yearLabel.text = nil
        } else {
            titleLabel.text = "Неизвестное название"
            englishTitleLabel.text = year
            yearLabel.text = nil
        }

        let countriesString = film.countries?
            .prefix(2)
            .map { $0.country }
            .joined(separator: ", ") ?? ""

        let genresString = film.genres?
            .prefix(2)
            .map { $0.genre }
            .joined(separator: ", ") ?? ""
        var detailsComponents: [String] = []

        if !countriesString.isEmpty {
            detailsComponents.append(countriesString)
        }

        if !genresString.isEmpty {
            detailsComponents.append(genresString)
        }

        detailsLabel.text = detailsComponents.joined(separator: " • ")

        if let posterUrl = film.posterUrlPreview ?? film.posterUrl,
           let url = URL(string: posterUrl) {
            filmImageView.setImage(url: url)
        } else {
            filmImageView.image = UIImage(systemName: "film")?
                .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        }
    }
}
