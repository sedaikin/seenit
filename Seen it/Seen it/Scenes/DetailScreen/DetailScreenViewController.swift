//
//  DetailScreenViewController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 25.08.2025.
//

import UIKit
import Combine

final class DetailScreenViewController: UIViewController {
    
    // MARK: - Properties

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private lazy var detailScreenView = DetailScreenView()
    private let defaults = UserDefaultsKeys()
    private lazy var isTracked = defaults.containsMovieId(id, in: .tracked)
    private lazy var isWatched = defaults.containsMovieId(id, in: .watched)
    private let viewModel: DetailScreenViewModel
    private var cancellables = Set<AnyCancellable>()
    private let id: Int
    
    // MARK: - Life cycle

    init(id: Int) {
        self.id = id
        self.viewModel = DetailScreenViewModel(filmId: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        setupUI()
        setupCustomBackButton()
        viewModel.loadData()
        detailScreenView.delegate = self
        view.backgroundColor = .background
    }
}

private extension DetailScreenViewController {
    
    // MARK: - Setup views
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let contentViewHeightAnchor = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        contentViewHeightAnchor.priority = .defaultLow
        contentViewHeightAnchor.isActive = true
    }
    
    private func setupDetailScreenView() {
        contentView.addSubview(detailScreenView)
        NSLayoutConstraint.activate([
            detailScreenView.topAnchor.constraint(equalTo: contentView.topAnchor),
            detailScreenView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailScreenView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailScreenView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
    
    // MARK: - Setup UI

    func setupUI () {
        setupScrollView()
        setupDetailScreenView()
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
    
}

// MARK: - Actions

private extension DetailScreenViewController {
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailScreenViewController: DetailScreenDelegate {
    func tapAddedButton() {
        let type = viewModel.detailInfo?.type == "FILM" ? "фильм" : "сериал"
        let title = isTracked ? "Удалить \(type) из списка того, что буду смотреть?" : "Добавить \(type) в список того, что буду смотреть?"
        showAlert(title: title)
    }
    
    func tapTrackedButton() {
        let type = viewModel.detailInfo?.type == "FILM" ? "фильм" : "сериал"
        let title = isWatched ? "Отметить \(type) как непросмотренный?" : "Отметить \(type) как просмотренный?"
        showAlert(title: title, isAdd: false)
    }
}


// MARK: - Alert

private extension DetailScreenViewController {
    func showAlert(title: String, isAdd: Bool = true) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self else { return }
            if isAdd {
                isTracked ? defaults.removeMovieId(id, from: .tracked) :
                            defaults.addMovieId(id, to: .tracked)
                isTracked = defaults.containsMovieId(id, in: .tracked)
                detailScreenView.updateAddedButton(isTracked)
            } else {
                isWatched ? defaults.removeMovieId(id, from: .watched) :
                            defaults.addMovieId(id, to: .watched)
                isWatched = defaults.containsMovieId(id, in: .watched)
                detailScreenView.updateWatchedButton(isWatched)
            }
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Setup binding


private extension DetailScreenViewController {
        
    func setupBinding() {
        viewModel.$detailInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] product in
                guard let viewModel = self?.viewModel else {
                    return
                }
                self?.detailScreenView.updateUI(viewModel)
                self?.detailScreenView.updateWatchedButton(self?.isWatched ?? true)
                self?.detailScreenView.updateAddedButton(self?.isTracked ?? true)
            }
            .store(in: &cancellables)
    }
    
}
