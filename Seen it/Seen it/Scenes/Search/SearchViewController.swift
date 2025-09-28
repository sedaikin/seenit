//
//  SearchViewController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

import UIKit

final class SearchViewController: UIViewController {

    // MARK: - UI Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private var filmsCollectionView: UICollectionView?
    private let topFilmsLabel = UILabel()
    private let searchResultsTableView = UITableView()
    private let emptyStateView = EmptyStateView()

    // MARK: - Data Properties
    private var films: [FilmItem] = []
    private var searchResults: [Film] = []
    private var isSearching: Bool = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupUIComponents()
        loadPopularFilms()
    }
}

// MARK: - Setup Methods
private extension SearchViewController {

    func setupAppearance() {
        view.backgroundColor = UIColor(named: "background")
    }

    func setupUIComponents() {
        setupSearchController()
        setupLabel()
        setupFilmsCollectionView()
        setupSearchResultsTableView()
        setupEmptyStateView()
    }

    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self

        searchController.searchBar.placeholder = "Поиск..."
        searchController.searchBar.backgroundColor = UIColor(named: "background")
        searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "tabbar")
        searchController.searchBar.searchTextField.textColor = .white

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    func setupLabel() {
        topFilmsLabel.text = "Популярное"
        topFilmsLabel.textColor = .white
        topFilmsLabel.textAlignment = .center
        topFilmsLabel.font = .systemFont(ofSize: 16, weight: .bold)
        topFilmsLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(topFilmsLabel)

        NSLayoutConstraint.activate([
            topFilmsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            topFilmsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topFilmsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func setupFilmsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 250)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .background

        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: HomeViewCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.alwaysBounceHorizontal = true

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topFilmsLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 270)
        ])

        filmsCollectionView = collectionView
    }

    func setupSearchResultsTableView() {
        searchResultsTableView.translatesAutoresizingMaskIntoConstraints = false
        searchResultsTableView.backgroundColor = UIColor(named: "background")
        searchResultsTableView.isHidden = true
        searchResultsTableView.alpha = 0

        searchResultsTableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseID)
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.separatorStyle = .none
        searchResultsTableView.rowHeight = 120

        view.addSubview(searchResultsTableView)

        NSLayoutConstraint.activate([
            searchResultsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupEmptyStateView() {
        view.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }

}

// MARK: - Data Loading
private extension SearchViewController {

    func loadPopularFilms() {
        NetworkManager.shared.loadCollection(type: filmsCollection.topAll.type, page: 1) { [weak self] result in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    self?.films.append(contentsOf: item.items)
                    self?.filmsCollectionView?.reloadData()
                }
            case .failure(let error):
                print("Error loading popular films: \(error)")
            }
        }
    }

    func performSearch(with searchText: String) {
        NetworkManager.shared.loadFilmsByKeyword(keyword: searchText, page: 1) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleSearchResult(result, for: searchText)
            }
        }
    }

    func handleSearchResult(_ result: Result<KeyboardResponse, Error>, for query: String) {
        switch result {
        case .success(let response):
            searchResults = response.films
            searchResultsTableView.reloadData()

            if response.films.isEmpty {
                showNoResultsState(for: query)
            } else {
                updateEmptyState()
            }

        case .failure(let error):
            print("Search error: \(error)")
            searchResults.removeAll()
            searchResultsTableView.reloadData()
            showErrorState(error: error)
        }
    }
}

// MARK: - UI State Management
private extension SearchViewController {

    func showSearchResults() {
        UIView.animate(withDuration: 0.3) {
            self.searchResultsTableView.alpha = 1
            self.searchResultsTableView.isHidden = false
            self.filmsCollectionView?.alpha = 0
            self.topFilmsLabel.alpha = 0
            self.updateEmptyState()
        }
    }

    func hideSearchResults() {
        UIView.animate(withDuration: 0.3) {
            self.searchResultsTableView.alpha = 0
            self.searchResultsTableView.isHidden = true
            self.emptyStateView.alpha = 0
            self.emptyStateView.isHidden = true
            self.filmsCollectionView?.alpha = 1
            self.topFilmsLabel.alpha = 1
        }
    }

    func updateEmptyState() {
        let isEmpty = isSearching && searchResults.isEmpty
        UIView.animate(withDuration: 0.3) {
            self.emptyStateView.alpha = isEmpty ? 1 : 0
            self.emptyStateView.isHidden = !isEmpty
        }
    }

    func showInitialSearchState() {
        emptyStateView.configure(with: .initialSearch)
        updateEmptyState()
    }

    func showLoadingState(for query: String) {
        emptyStateView.configure(with: .loading(query: query))
        updateEmptyState()
    }

    func showNoResultsState(for query: String) {
        emptyStateView.configure(with: .noResults(query: query))
        updateEmptyState()
    }

    func showErrorState(error: Error) {
        emptyStateView.configure(with: .error(error))
        updateEmptyState()
    }

    func errorMessage(for error: Error) -> String {
        guard let networkError = error as? NetworkError else {
            return "Произошла ошибка при поиске"
        }

        switch networkError {
        case .serverError(let statusCode):
            return "Ошибка сервера (\(statusCode))"
        case .noData:
            return "Нет данных от сервера"
        case .invalidURL:
            return "Неверный URL запроса"
        case .decodingError:
            return "Ошибка обработки данных"
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? searchResults.count : films.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeViewCell.reuseID,
            for: indexPath
        ) as? HomeViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: films[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let filmItem = films[indexPath.row]
        navigateToFilmDetails(with: filmItem.id)

        if searchController.isActive {
            searchController.isActive = false
        }
    }

    private func navigateToFilmDetails(with id: Int) {
        let singleItemController = SingleItemController(id: id)
        singleItemController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(singleItemController, animated: true)
    }
}

// MARK: - UITableView DataSource & Delegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultCell.reuseID,
            for: indexPath
        ) as? SearchResultCell else {
            return UITableViewCell()
        }

        let film = searchResults[indexPath.row]
        cell.configure(with: film)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let film = searchResults[indexPath.row]
        navigateToFilmDetails(with: film.filmId)
        searchController.isActive = false
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            searchResults.removeAll()
            searchResultsTableView.reloadData()
            showInitialSearchState()
            return
        }

        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(executeSearch(_:)), with: searchText, afterDelay: 1)
        showLoadingState(for: searchText)
    }

    @objc private func executeSearch(_ searchText: String) {
        performSearch(with: searchText)
    }
}

// MARK: - UISearchControllerDelegate
extension SearchViewController: UISearchControllerDelegate {

    func willPresentSearchController(_ searchController: UISearchController) {
        showSearchResults()
        isSearching = true
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        hideSearchResults()
        isSearching = false
        searchResults.removeAll()
        emptyStateView.isHidden = true
    }
}
