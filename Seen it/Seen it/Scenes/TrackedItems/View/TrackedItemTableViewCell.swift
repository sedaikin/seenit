//
//  TrackedItemTableViewCell.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

import UIKit

protocol TrackedItemDelegate: AnyObject {
    func didTapButtonInCell(_ cell: TrackedItemTableViewCell, at indexPath: IndexPath)
}

final class TrackedItemTableViewCell: UITableViewCell {
    static let reuseID = "TrackedItemTableViewCell"
    
    private var name: UILabel = {
        let label = UILabel()
        label.configBigText(.white)
        return label
    }()
    
    private let year: UILabel = {
        let label = UILabel()
        label.configSmallText()
        return label
    }()
    
    private let duration: UILabel = {
        let label = UILabel()
        label.configSmallText()
        return label
    }()
    
    private let image: RemoteImageView = {
        let image = RemoteImageView()
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let buttonTracked: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapTrackedButton), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        return button
    }()
    
    var trackedItem: DetailScreenModel?
    
    weak var delegate: TrackedItemDelegate?
    var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Prepare for reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.prepareForReuse()
        duration.text = nil
    }
    
}

private extension TrackedItemTableViewCell {
    
    // MARK: - Setup UI
    
    func setupUI() {
        contentView.addSubviews(
            image,
            name,
            year,
            duration,
            buttonTracked
        )
        backgroundColor = .background
    }
    
    // MARK: - Setup layout
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            image.widthAnchor.constraint(equalToConstant: 60),
            image.heightAnchor.constraint(equalToConstant: 90),
            
            name.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 16),
            name.trailingAnchor.constraint(equalTo: buttonTracked.leadingAnchor, constant: 0),
            name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            
            year.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 16),
            year.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 6),
            year.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -34),
            year.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
            
            duration.leadingAnchor.constraint(equalTo: year.trailingAnchor, constant: 0),
            duration.trailingAnchor.constraint(equalTo: buttonTracked.leadingAnchor, constant: 0),
            duration.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 6),
            
            buttonTracked.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            buttonTracked.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            buttonTracked.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
}

extension TrackedItemTableViewCell {
    
    // MARK: - Cell configuration
    
    func configure(with trackedItem: DetailScreenModel) {
        self.trackedItem = trackedItem
        
        guard let url = URL(string: trackedItem.image) else {
            return
        }
   
        name.text = trackedItem.name
        year.text = String(trackedItem.year)
        image.setImage(url: url)
        let isWatched = UserDefaultsKeys().containsMovieId(trackedItem.id, in: .watched)
        buttonTracked.setImage(UIImage(systemName: isWatched ? "eye.fill" : "eye"), for: .normal)
        buttonTracked.tintColor = isWatched ? .active : .systemGray3
        
        if let allDuration = trackedItem.duration {
            let hours = String(allDuration/60)
            let minutes = String(allDuration%60)
            
            duration.text = " \u{2022} " + (hours != "0" ? hours + " \(String(localized: "hours")) " : "") + minutes + " \(String(localized: "mins"))"
        }
        
        setNeedsLayout()
    }
}

private extension TrackedItemTableViewCell {
    
    // MARK: - Actions

    @objc
    func didTapTrackedButton(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.didTapButtonInCell(self, at: indexPath)
        }
    }
}
