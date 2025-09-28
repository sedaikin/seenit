//
//  SearchViewController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

import UIKit

final class SearchViewController: UIViewController {

    // MARK: - Private properties
    private let searchController = UISearchController(searchResultsController: nil)
    private var filmsCollectionView: UICollectionView?
    private let topFilmsLabel = UILabel()
    private var films: [FilmItem] = []
    private var filteredFilms: [FilmItem] = []
    private var isSearching: Bool = false

    private let searchResultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "background")
        tableView.isHidden = true
        tableView.alpha = 0
        return tableView
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "background")
        setupSearchController()
        setupLabel()
        setupFilmsCollectionView()
        setupSearchResultsTableView()

        NetworkManager.shared.loadCollection(type: filmsCollection.topAll.type, page: 1) { result in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    self.films.append(contentsOf: item.items)
                    self.filmsCollectionView?.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

private extension SearchViewController {

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

    func setupSearchResultsTableView() {
        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.separatorStyle = .none

        view.addSubview(searchResultsTableView)

        NSLayoutConstraint.activate([
            searchResultsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
            collectionView.heightAnchor.constraint(equalToConstant: 200)
        ])

        filmsCollectionView = collectionView
    }

    private func showSearchResults() {
        UIView.animate(withDuration: 0.3) {
            self.searchResultsTableView.alpha = 1
            self.searchResultsTableView.isHidden = false

            self.filmsCollectionView?.alpha = 0
            self.topFilmsLabel.alpha = 0
        }
    }

    private func hideSearchResults() {
        UIView.animate(withDuration: 0.3) {
            self.searchResultsTableView.alpha = 0
            self.searchResultsTableView.isHidden = true

            self.filmsCollectionView?.alpha = 1
            self.topFilmsLabel.alpha = 1
        }
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return filteredFilms.count
        }
        return films.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCell.reuseID, for: indexPath) as? HomeViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: films[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let filmItem = films[indexPath.row]
        let singleItemController = SingleItemController(id: filmItem.id)
        singleItemController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(singleItemController, animated: true)

        if searchController.isActive {
            searchController.isActive = false
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredFilms.removeAll()
            searchResultsTableView.reloadData()
            return
        }

        filteredFilms = films.filter { film in
            film.name.lowercased().contains(searchText.lowercased())
        }

        searchResultsTableView.reloadData()
    }
}

extension SearchViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        showSearchResults()
        isSearching = true
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        hideSearchResults()
        isSearching = false
        filteredFilms.removeAll()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFilms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        let film = filteredFilms[indexPath.row]

        // Настройка ячейки
        cell.textLabel?.text = film.name
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(named: "background")
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filmItem = filteredFilms[indexPath.row]
        let singleItemController = SingleItemController(id: filmItem.id)
        singleItemController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(singleItemController, animated: true)

        searchController.isActive = false
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
