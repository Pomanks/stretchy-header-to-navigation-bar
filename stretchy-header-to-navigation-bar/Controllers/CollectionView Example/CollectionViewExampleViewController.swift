//
//  CollectionViewExampleViewController.swift
//  stretchy-header-to-navigation-bar
//
//  Created by Antoine Barre on 3/10/20.
//  Copyright © 2020 Pomanks. All rights reserved.
//

import UIKit

final class CollectionViewExampleViewController: UIViewController {

    enum Section {
        case main
    }

    // MARK: - Members

    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    var collectionView: UICollectionView!

    var animator: UIViewPropertyAnimator?
    var transitionTopConstraint: NSLayoutConstraint!
    var transitionHeightConstraint: NSLayoutConstraint!
    var overlayBottomConstraint: NSLayoutConstraint!
    var overlayHeightConstraint: NSLayoutConstraint!

    private(set) lazy var overlayOffset: CGPoint = .zero

    private(set) lazy var stretchyHeaderView: StretchyHeaderViewToNavigationBarTransitionView = {
        let view = StretchyHeaderViewToNavigationBarTransitionView(navigationUnderlayHeight: navigationControllerHeight)

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private(set) lazy var overlayHeaderView: OverlayHeaderView = {
        let view = OverlayHeaderView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear

        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)

        configureHierarchy()
        configureScrollViewHierarchy()
        configureDataSource()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollViewWillLayoutSubviews()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        scrollViewWillTransition(to: size, with: coordinator)
    }
}

extension CollectionViewExampleViewController: UICollectionViewDelegate {}

extension CollectionViewExampleViewController: StretchyHeaderViewToNavigationBarTransitioning {

    var scrollView: UIScrollView {
        return collectionView
    }

    var transitionView: StretchyHeaderViewToNavigationBarTransitionCapable {
        return stretchyHeaderView
    }

    var overlayView: OverlayViewTransitionCapable {
        return overlayHeaderView
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidPerformTransition()
    }
}
