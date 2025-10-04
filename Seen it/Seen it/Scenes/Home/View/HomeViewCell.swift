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
    
    private let name: UILabel = {
        let label = UILabel()
        label.configSmallText()
        return label
    }()
    
    private let year: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let image: RemoteImageView = {
        let image = RemoteImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
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
        
        contentView.addSubviews(image, name, year)
        setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: 180),
            
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16),
            
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
        
        guard let fullYear = trackedItem.year else {
            return
        }
   
        name.text = trackedItem.name
        year.text = String(fullYear)
        image.setImage(url: url)
        
        setNeedsLayout()
    }
    
}
