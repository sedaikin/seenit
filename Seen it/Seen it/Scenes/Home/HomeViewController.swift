//
//  HomeViewController.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 19.08.2025.
//

import UIKit

struct Section: Hashable {
    let id: Int
    let title: String
    var items: [FilmItem]
}

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var collectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, FilmItem>?
    var sections = [
        Section(id: 1, title: String(localized: "topFilms") + getCurrentYear(), items: []),
        Section(id: 2, title: String(localized: "topShows"), items: [])
    ]
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        configureDataSource()
        loadData()
    }
    
}

// MARK: - Private

private extension HomeViewController {
    
    // MARK: - Setup collectionView with UICollectionViewLayout
    
    func setupCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: HomeViewCell.reuseID)
        collectionView.register(SectionHeaderView.self,
                               forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.backgroundColor = .background
        collectionView.delegate = self
        
        self.collectionView = collectionView
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            return self?.createSectionLayout()
        }
    }
    
    func createSectionLayout() -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(150),
                heightDimension: .absolute(270)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: 32,
                trailing: 0
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
            
            return section
        }
    
    func configureDataSource() {
        guard let collectionView = collectionView else {
            return
        }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, FilmItem>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, filmItem in
                self.createCell(collectionView: collectionView, indexPath: indexPath, filmItem: filmItem)
            }
        )
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            self.createHeader(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
        
        self.dataSource = dataSource
    }
    
    func createCell(collectionView: UICollectionView, indexPath: IndexPath, filmItem: FilmItem) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeViewCell.reuseID,
            for: indexPath
        ) as? HomeViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: filmItem)
        return cell
    }
        
    func createHeader(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        guard kind == UICollectionView.elementKindSectionHeader else { return nil }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        
        if let snapshot = dataSource?.snapshot(), indexPath.section < snapshot.sectionIdentifiers.count {
           let section = snapshot.sectionIdentifiers[indexPath.section]
           header.configure(with: section.title)
       }
       
       return header
    }

     func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FilmItem>()
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
}

private extension HomeViewController {
    
    // MARK: Load data
    
    func loadData() {
        
        let loadDataQueue = DispatchQueue(label: "ru.seenit.collection")
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        loadDataQueue.async{
            NetworkManager.shared.loadCollection(type: filmsCollection.topMovies.type, page: 1) { [weak self] result in
                guard let self else { return }
                defer { dispatchGroup.leave() }
                
                switch result {
                case .success(let item):
                    DispatchQueue.main.async {
                        self.sections[0].items.append(contentsOf: item.items)
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
                        self.sections[1].items.append(contentsOf: item.items)
                    }
                case .failure(let error):
                    print("Shows error:", error)
                }
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.applySnapshot()
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at:indexPath, animated: true)
        guard let dataSource = dataSource,
              let singleItem = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        let singleItemController = SingleItemController(id: singleItem.id)
        navigationController?.pushViewController(singleItemController, animated: true)
    }
}

extension HomeViewController {
    
    static func getCurrentYear() -> String {
        String(Calendar.current.component(.year, from: Date()))
    }
}
