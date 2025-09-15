//
//  HomeViewController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var filmsCollectionView = UICollectionView()
    private lazy var showsCollectionView = UICollectionView()
    private let topFilmsLabel = UILabel()
    private let topShowsLabel = UILabel()
    private var films: [FilmItem] = []
    private var shows: [FilmItem] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "background")
        
        addSubviews()
        setupFilmsCollectionView()
        setupShowsCollectionView()
        
        setupLabel()
        setupShowsLabel()
        
        loadData()
    }
    
}

// MARK: - Private

private extension HomeViewController {
    
    func addSubviews() {
        view.addSubviews(topFilmsLabel, topShowsLabel)
    }
    
    func setupFilmsCollectionView() {
    
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 250)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        filmsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        filmsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        filmsCollectionView.backgroundColor = .background
    
        filmsCollectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: HomeViewCell.reuseID)
        
        filmsCollectionView.delegate = self
        filmsCollectionView.dataSource = self
        filmsCollectionView.layer.masksToBounds = true
    
        filmsCollectionView.showsHorizontalScrollIndicator = true
        filmsCollectionView.alwaysBounceHorizontal = true
        
        view.addSubview(filmsCollectionView)
    
        NSLayoutConstraint.activate([
            filmsCollectionView.topAnchor.constraint(equalTo: topFilmsLabel.bottomAnchor, constant: 16),
            filmsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filmsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filmsCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func setupShowsCollectionView() {
    
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 250)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        showsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        showsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        showsCollectionView.backgroundColor = .background
    
        showsCollectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: HomeViewCell.reuseID)
        
        showsCollectionView.delegate = self
        showsCollectionView.dataSource = self
    
        showsCollectionView.showsHorizontalScrollIndicator = true
        showsCollectionView.alwaysBounceHorizontal = true
        
        view.addSubview(showsCollectionView)
    
        NSLayoutConstraint.activate([
            showsCollectionView.topAnchor.constraint(equalTo: topShowsLabel.bottomAnchor, constant: 16),
            showsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            showsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            showsCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func setupLabel() {
        topFilmsLabel.text = "Топ фильмов \(Calendar.current.component(.year, from: Date()))"
        topFilmsLabel.textColor = .white
        topFilmsLabel.textAlignment = .center
        topFilmsLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        topFilmsLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topFilmsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            topFilmsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topFilmsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupShowsLabel() {
        topShowsLabel.text = "Топ всех сериалов"
        topShowsLabel.textColor = .white
        topShowsLabel.textAlignment = .center
        topShowsLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        topShowsLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topShowsLabel.topAnchor.constraint(equalTo: filmsCollectionView.bottomAnchor, constant: 24),
            topShowsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topShowsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension HomeViewController {
    func loadData() {
        
       let loadDataQueue = DispatchQueue(label: "ru.seenit.collection")
//       let dispatchGroup = DispatchGroup()
//
//       let loadFilms = DispatchWorkItem { [weak self] in
//           NetworkManager.shared.loadCollection(type: filmsCollection.topMovies.type, page: 1) { result in
//               guard let self else { return }
//
//               switch result {
//               case .success(let item):
//                    self.films.append(contentsOf: item.items)
//               case .failure(let error):
//                   print("Films error:", error)
//               }
//           }
//       }
//
//       let loadShows = DispatchWorkItem { [weak self] in
//           NetworkManager.shared.loadCollection(type: filmsCollection.topShows.type, page: 1) { result in
//               guard let self else { return }
//
//               switch result {
//               case .success(let item):
//                    self.shows.append(contentsOf: item.items)
//               case .failure(let error):
//                   print("Shows error:", error)
//               }
//           }
//       }
//
//       loadDataQueue.async(group: dispatchGroup, execute: loadFilms)
//       loadDataQueue.async(group: dispatchGroup, execute: loadShows)
//
//       dispatchGroup.notify(queue: .main) { [weak self] in
//           guard let self else { return }
//           self.filmsCollectionView.reloadData()
//           self.showsCollectionView.reloadData()
//       }
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        loadDataQueue.async{
            NetworkManager.shared.loadCollection(type: filmsCollection.topMovies.type, page: 1) { [weak self] result in
                guard let self else { return }
                defer { dispatchGroup.leave() }
                
                switch result {
                case .success(let item):
                    DispatchQueue.main.async {
                        self.films.append(contentsOf: item.items)
                    }
                case .failure(let error):
                    print("Films error:", error)
                }
            }
        }
        
        dispatchGroup.enter()
        loadDataQueue.async{
            NetworkManager.shared.loadCollection(type: filmsCollection.topShows.type, page: 1) { [weak self] result in
                guard let self else { return }
                defer { dispatchGroup.leave() }
                
                switch result {
                case .success(let item):
                    DispatchQueue.main.async {
                        self.shows.append(contentsOf: item.items)
                    }
                case .failure(let error):
                    print("Shows error:", error)
                }
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.filmsCollectionView.reloadData()
            self.showsCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case filmsCollectionView:
                films.count
            case showsCollectionView:
                shows.count
        default:
            0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCell.reuseID, for: indexPath) as? HomeViewCell else {
            return UICollectionViewCell()
        }
        
        if collectionView == filmsCollectionView {
            cell.configure(with: films[indexPath.item])
        } else {
            cell.configure(with: shows[indexPath.item])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at:indexPath, animated: true)
        var singleItem: FilmItem
        
        if collectionView == filmsCollectionView {
            singleItem = films[indexPath.row]
        } else {
            singleItem = shows[indexPath.row]
        }
        let singleItemController = SingleItemController(singleItem: singleItem)
        singleItemController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(singleItemController, animated: true)
    }
}
