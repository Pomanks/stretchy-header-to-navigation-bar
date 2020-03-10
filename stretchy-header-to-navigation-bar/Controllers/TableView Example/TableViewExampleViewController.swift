//
//  TableViewExampleViewController.swift
//  stretchy-header-to-navigation-bar
//
//  Created by Antoine Barre on 3/9/20.
//  Copyright © 2020 Pomanks. All rights reserved.
//

import UIKit

final class TableViewExampleViewController: UIViewController {

    // MARK: - Members

    var animator: UIViewPropertyAnimator?
    var transitionTopConstraint: NSLayoutConstraint!
    var transitionHeightConstraint: NSLayoutConstraint!
    var overlayBottomConstraint: NSLayoutConstraint!
    var overlayHeightConstraint: NSLayoutConstraint!

    private(set) lazy var overlayOffset: CGPoint = .zero

    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")

        return tableView
    }()

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
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollViewWillLayoutSubviews()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        scrollViewWillTransition(to: size, with: coordinator)
    }

    func configureHierarchy() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TableViewExampleViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3000
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        cell.textLabel?.text = "This is your content"

        return cell
    }
}

extension TableViewExampleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .systemBackground
    }
}

extension TableViewExampleViewController: StretchyHeaderViewToNavigationBarTransitioning {

    var scrollView: UIScrollView {
        return tableView
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
