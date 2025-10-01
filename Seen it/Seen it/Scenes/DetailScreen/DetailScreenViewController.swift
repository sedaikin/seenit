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

    private let defaults = UserDefaultsKeys()
    private lazy var isTracked = defaults.containsMovieId(id, in: .tracked)
    private lazy var isWatched = defaults.containsMovieId(id, in: .watched)
    private lazy var detailScreenView = DetailScreenView()
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
    
    override func loadView() {
        view = detailScreenView
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailScreenView.delegate = self
        setupBinding()
        setupUI()
        setupCustomBackButton()
        viewModel.loadData()
    }
}

private extension DetailScreenViewController {
    
    // MARK: - Setup UI

    func setupUI () {
        view.backgroundColor = .background
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
