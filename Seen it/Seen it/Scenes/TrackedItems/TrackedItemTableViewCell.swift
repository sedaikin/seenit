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
    
    private let name = UILabel()
    private let year = UILabel()
    private let duration = UILabel()
    private let image = RemoteImageView()
    private let buttonTracked = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    
    var trackedItem: FilmItem?
    
    weak var delegate: TrackedItemDelegate?
    var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Prepare for reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
    }
    
    // MARK: - Public
    
    func configure(with trackedItem: FilmItem) {
        self.trackedItem = trackedItem
        
        if let allDuration = trackedItem.duration {
            let hours = String(allDuration/60)
            let minutes = String(allDuration%60)
            
            duration.text = " \u{2022} " + (hours != "0" ? hours + " \(String(localized: "hours")) " : "") + minutes + " \(String(localized: "mins"))"
        }
        
        let isTracked = IsTracked().isTracked
        
        guard let url = URL(string: trackedItem.image) else {
            return
        }
   
        name.text = trackedItem.name
        year.text = String(trackedItem.year)
        image.setImage(url: url)
        buttonTracked.setImage(UIImage(systemName: isTracked ? "eye.fill" : "eye"), for: .normal)
        buttonTracked.tintColor = isTracked ? .active : .white
        
        setNeedsLayout()
    }
}

private extension TrackedItemTableViewCell {
    
    // MARK: - Setup views
    
    func setup() {
        contentView.addSubview(name)
        contentView.addSubview(year)
        contentView.addSubview(duration)
        contentView.addSubview(image)
        contentView.addSubview(buttonTracked)
        
        backgroundColor = .background
        
        setupItemImage()
        setupItemName()
        setupItemYear()
        setupTrackedButton()
        setupItemDuration()
    }
    
    func setupItemImage() {
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            image.widthAnchor.constraint(equalToConstant: 60),
            image.heightAnchor.constraint(equalToConstant: 90),
        ])
    }
    
    func setupItemName() {
        name.font = .systemFont(ofSize: 16, weight: .bold)
        name.textColor = .white
        name.numberOfLines = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            name.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 16),
            name.trailingAnchor.constraint(equalTo: buttonTracked.leadingAnchor, constant: 0),
            name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0)
        ])
    }
    
    func setupItemYear() {
        year.font = .systemFont(ofSize: 12, weight: .light)
        year.textColor = .systemGray4
        
        year.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            year.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 16),
            year.trailingAnchor.constraint(equalTo: duration.leadingAnchor, constant: 0),
            year.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 6),
            year.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -34)
        ])
    }
    
    func setupItemDuration() {
        duration.font = .systemFont(ofSize: 12, weight: .light)
        duration.textColor = .systemGray4
        
        duration.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            duration.leadingAnchor.constraint(equalTo: year.trailingAnchor, constant: 0),
            duration.trailingAnchor.constraint(equalTo: buttonTracked.leadingAnchor, constant: 0),
            duration.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 6),
        ])
    }
    
    func setupTrackedButton() {
        buttonTracked.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonTracked.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            buttonTracked.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            buttonTracked.widthAnchor.constraint(equalToConstant: 40),
        ])
        buttonTracked.addTarget(self, action: #selector(didTapTrackedButton), for: .touchUpInside)
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
