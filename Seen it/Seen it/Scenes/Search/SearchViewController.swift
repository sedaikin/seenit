//
//  SearchViewController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

import UIKit
import Combine

final class SearchViewController: BaseViewController {

    // MARK: - UI Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private var filmsCollectionView: UICollectionView?
    private let topFilmsLabel = UILabel()
    private let searchResultsTableView = UITableView()
    private let emptyStateView = EmptyStateView()

    // MARK: - Combine
    private let viewModel = SearchScreenViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupUIComponents()
        bindViewModel()
        viewModel.loadPopularFilms()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restoreSearchState()
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

        searchController.searchBar.backgroundColor = UIColor(named: "background")
        searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "tabbar")
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Поиск...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        searchController.searchBar.searchTextField.leftView?.tintColor = .active

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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)

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

    func bindViewModel() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.handleLoadingState(isLoading)
            }
            .store(in: &cancellables)

        viewModel.$searchState
            .map { $0.films }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] films in
                self?.filmsCollectionView?.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$searchState
            .map { $0.searchResults }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] searchResults in
                self?.searchResultsTableView.reloadData()
                self?.updateEmptyState()
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showErrorState(message: errorMessage)
                }
            }
            .store(in: &cancellables)

        viewModel.$searchState
            .map { $0.isSearching }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSearching in
                self?.handleSearchingState(isSearching)
            }
            .store(in: &cancellables)
    }

    func restoreSearchState() {
        guard let lastQuery = viewModel.restoreSearchState(), !lastQuery.isEmpty else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.searchController.searchBar.text = lastQuery
            self.searchController.isActive = true
            self.viewModel.setSearching(true)
            self.viewModel.performSearch(query: lastQuery)
            self.viewModel.clearSearchState()
        }
    }
}

// MARK: - UI State Management
private extension SearchViewController {

    func handleLoadingState(_ isLoading: Bool) {
        updateEmptyState()
    }

    func handleSearchingState(_ isSearching: Bool) {
        if isSearching {
            showSearchResults()
        } else {
            hideSearchResults()
        }
    }

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
        let searchState = viewModel.searchState
        let shouldShowEmptyState: Bool

        if viewModel.isLoading {
            shouldShowEmptyState = viewModel.searchState.searchResults.isEmpty
            if shouldShowEmptyState && !searchState.searchQuery.isEmpty {
                emptyStateView.configure(with: .loading(query: searchState.searchQuery))
            }
        } else {
            shouldShowEmptyState = searchState.isSearching && searchState.searchResults.isEmpty
            if shouldShowEmptyState {
                if searchState.searchQuery.isEmpty {
                    emptyStateView.configure(with: .initialSearch)
                } else {
                    emptyStateView.configure(with: .noResults(query: searchState.searchQuery))
                }
            }
        }

        UIView.animate(withDuration: 0.3) {
            self.emptyStateView.alpha = shouldShowEmptyState ? 1 : 0
            self.emptyStateView.isHidden = !shouldShowEmptyState
        }
    }

    func showErrorState(message: String) {
        struct DisplayError: Error {
            let message: String
        }
        let error = DisplayError(message: message)
        emptyStateView.configure(with: .error(error))
        UIView.animate(withDuration: 0.3) {
            self.emptyStateView.alpha = 1
            self.emptyStateView.isHidden = false
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchState.films.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeViewCell.reuseID,
            for: indexPath
        ) as? HomeViewCell else {
            return UICollectionViewCell()
        }

        let filmItem = viewModel.searchState.films[indexPath.item]
        cell.configure(with: filmItem)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let filmItem = viewModel.searchState.films[indexPath.row]
        if searchController.isActive {
            viewModel.saveSearchState(
                query: viewModel.searchState.searchQuery,
                results: viewModel.searchState.searchResults
            )
        }
        navigateToFilmDetails(with: filmItem.id)
    }

    private func navigateToFilmDetails(with id: Int) {
        let singleItemController = DetailScreenViewController(id: id)
        singleItemController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(singleItemController, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchState.searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultCell.reuseID,
            for: indexPath
        ) as? SearchResultCell else {
            return UITableViewCell()
        }

        let film = viewModel.searchState.searchResults[indexPath.row]
        cell.configure(with: film)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let film = viewModel.searchState.searchResults[indexPath.row]
        viewModel.saveSearchState(
            query: viewModel.searchState.searchQuery,
            results: viewModel.searchState.searchResults
        )
        navigateToFilmDetails(with: film.filmId)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        if searchText.isEmpty {
            viewModel.clearSearch()
            searchResultsTableView.reloadData()
            updateEmptyState()
            return
        }

        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(executeSearch(_:)), with: searchText, afterDelay: 1)
        updateEmptyState()
    }

    @objc private func executeSearch(_ searchText: String) {
        viewModel.performSearch(query: searchText)
    }
}

// MARK: - UISearchControllerDelegate
extension SearchViewController: UISearchControllerDelegate {

    func willPresentSearchController(_ searchController: UISearchController) {
        showSearchResults()
        viewModel.setSearching(true)
        searchController.searchBar.searchTextField.textColor = .white
    }

    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.searchTextField.textColor = .white
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        let hasSavedSearch = viewModel.restoreSearchState() != nil

        if !hasSavedSearch {
            hideSearchResults()
            viewModel.setSearching(false)
            viewModel.clearSearch()
            emptyStateView.isHidden = true
        }
    }
}
