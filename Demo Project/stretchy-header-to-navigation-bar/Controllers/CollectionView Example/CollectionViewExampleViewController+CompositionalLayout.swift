//
//  CollectionViewExampleViewController+CompositionalLayout.swift
//  stretchy-header-to-navigation-bar
//
//  Created by Antoine Barre on 3/10/20.
//  Copyright © 2020 Pomanks. All rights reserved.
//

// Inspired from : https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/using_collection_view_compositional_layouts_and_diffable_data_sources

import UIKit

extension CollectionViewExampleViewController {

    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeCompositionalLayout())

        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset.bottom = 34
        collectionView.delegate = self
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.reuseIdentifier)

        view.addSubview(collectionView)
    }

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in

            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TextCell.reuseIdentifier,
                for: indexPath
            ) as? TextCell
            else { fatalError("Cannot create new cell") }

            // Populate the cell with our item description.
            cell.label.text = "\(identifier)"
            cell.contentView.backgroundColor = .systemOrange
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)

            // Return the cell.
            return cell
        }
        dataSource.supplementaryViewProvider = supplementaryViewProvider()

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()

        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0 ..< 94))

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider())

        layout.register(
            SectionBackgroundDecorationView.self,
            forDecorationViewOfKind: SectionBackgroundDecorationView.elementKind
        )
        return layout
    }

    func sectionProvider() -> UICollectionViewCompositionalLayoutSectionProvider {
        return { _, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            let numberOfItems = self.maximumNumberOfItems(for: layoutEnvironment, matching: 100)
            let ratio = layoutEnvironment.container.effectiveContentSize.width / CGFloat(numberOfItems)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(ratio)
            )
            let group: NSCollectionLayoutGroup = .horizontal(layoutSize: groupSize, subitem: item, count: numberOfItems)
            let section = NSCollectionLayoutSection(group: group)

            section.decorationItems = [.background(elementKind: SectionBackgroundDecorationView.elementKind)]

            return section
        }
    }

    func supplementaryViewProvider() -> UICollectionViewDiffableDataSource<Section, Int>.SupplementaryViewProvider? {
        return { collectionView, kind, indexPath in
            switch kind {
            case SectionBackgroundDecorationView.elementKind:
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: kind,
                    for: indexPath
                )

            default:
                return nil
            }
        }
    }
}

// MARK: - Helpers

private extension CollectionViewExampleViewController {

    func maximumNumberOfItems(for layoutEnvironment: NSCollectionLayoutEnvironment, matching minWidth: CGFloat) -> Int {
        let width = layoutEnvironment.container.effectiveContentSize.width
        let maxNumberOfItems = (width / minWidth).rounded(.toNearestOrEven)

        return Int(maxNumberOfItems)
    }
}
