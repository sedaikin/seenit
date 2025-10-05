//
//  HomeViewCollection.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 04.10.2025.
//

import UIKit

// MARK: - Struct for section in collection

struct Section: Hashable {
    let id: Int
    let title: String
    var items: [FilmItem]
}

// MARK: - Navigation delegate

protocol NavigationDelegate: AnyObject {
    func navigateToNewScreen(to: UIViewController)
}

final class HomeViewCollection: UIView, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    weak var delegate: NavigationDelegate?
    private var collectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, FilmItem>?
    var sections = [
        Section(id: 1, title: String(localized: "topFilms") + getCurrentYear(), items: []),
        Section(id: 2, title: String(localized: "topShows"), items: [])
    ]
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups for collection
    
    func setupCollectionView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        addSubview(collectionView)
        
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: HomeViewCell.reuseID)
        collectionView.register(SectionHeaderView.self,
                               forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.backgroundColor = .background
        collectionView.delegate = self
        
        self.collectionView = collectionView
    }
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            self?.createSectionLayout()
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
            heightDimension: .estimated(290)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
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
    
    // MARK: - Config for data
    
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
    
    func applySnapshot() {
       var snapshot = NSDiffableDataSourceSnapshot<Section, FilmItem>()
       snapshot.appendSections(sections)
       
       for section in sections {
           snapshot.appendItems(section.items, toSection: section)
       }
       
       dataSource?.apply(snapshot, animatingDifferences: true)
   }
}

// MARK: - Did select func

extension HomeViewCollection {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at:indexPath, animated: true)
        guard let dataSource = dataSource,
              let singleItem = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        let singleItemController = DetailScreenViewController(id: singleItem.id)
        delegate?.navigateToNewScreen(to: singleItemController)
    }
}

extension HomeViewCollection {
    static func getCurrentYear() -> String {
        String(Calendar.current.component(.year, from: Date()))
    }
}
