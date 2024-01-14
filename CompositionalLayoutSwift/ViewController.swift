//
//  ViewController.swift
//  CompositionalLayoutSwift
//
//  Created by Khristoffer Julio on 1/14/24.
//

import UIKit

class GridCellView: UICollectionViewCell {
    let label: UILabel = UILabel()
    static let reuseIdentifier = "text-cell-reuse-identifier"
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        contentView.addSubview(label)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
            ])
    }
}

class ViewController: UIViewController {
    enum Section: Int { case main, games, chat }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            switch Section(rawValue: sectionIndex) {
            case .main: 
                return self.firstSection()
                
            case .games:
                return self.secondSection()
                
            case .chat:
                return self.thirdSection()
                
            default: return nil
            }

        }
        return layout
    }
    
    private func firstSection() -> NSCollectionLayoutSection {
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)))
        leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let leadingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.7),
                heightDimension: .fractionalHeight(1.0)),
            subitem: leadingItem, count: 2)

        let trailingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(0.3)))
        trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                              heightDimension: .fractionalHeight(1.0)),
            subitem: trailingItem, count: 3)

        let nestedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(0.4)),
            subitems: [leadingGroup, trailingGroup])
        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func secondSection() -> NSCollectionLayoutSection {
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)))
        leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let trailingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0)))
        trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let nestedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.4)),
            subitems: [leadingItem, trailingItem])
        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func thirdSection() -> NSCollectionLayoutSection {
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3)))
        leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let leadingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.9),
                heightDimension: .fractionalHeight(0.4)),
            subitem: leadingItem, count: 3)
 
        let section = NSCollectionLayoutSection(group: leadingGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }

    private func setupUI() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func setupData() {
        let cellRegistration = UICollectionView.CellRegistration<GridCellView, Int> {
            (cell, indexPath, identifier) in
            
            cell.label.text = "\(indexPath.section), \(indexPath.item)"
            cell.contentView.backgroundColor = .lightGray
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        let itemsPerSection = 30
        var identifierOffset = 0
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
         
        for section in [Section.main, Section.games, Section.chat] {
            snapshot.appendSections([section])
            let maxIdentifier = identifierOffset + itemsPerSection
            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
            identifierOffset += itemsPerSection
        }
          
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
