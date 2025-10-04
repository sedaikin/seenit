//
//  HomeViewCell.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 07.09.2025.
//

import UIKit

final class HomeViewCell: UICollectionViewCell {
    
    static let reuseID = "HomeViewCell"
    
    // MARK: - Properties
    
    private let name = UILabel()
    private let year = UILabel()
    private let duration = UILabel()
    private let image = RemoteImageView()
    var trackedItem: FilmItem?
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Prepare for reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.prepareForReuse()
    }
}

private extension HomeViewCell {
    
    // MARK: - Setup UI
    
    func setupUI() {
        contentView.layer.masksToBounds = true
        
        contentView.addSubviews(image, name, year, duration)
        setupLabel()
        setupItemImage()
        setupItemYear()
    }
    
    func setupItemImage() {
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    func setupLabel() {
        name.textAlignment = .left
        name.textColor = .white
        name.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16)
        ])
    }
    
    func setupItemYear() {
        year.font = .systemFont(ofSize: 12, weight: .light)
        year.textColor = .systemGray4
        
        year.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            year.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            year.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            year.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
        ])
    }
}

extension HomeViewCell {
    
    // MARK: - Cell configuration
    
    func configure(with trackedItem: FilmItem) {
        self.trackedItem = trackedItem
        
        guard let url = URL(string: trackedItem.image) else {
            return
        }
   
        name.text = trackedItem.name
        year.text = String(trackedItem.year)
        image.setImage(url: url)
        
        setNeedsLayout()
    }
    
}
