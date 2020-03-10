//
//  StretchyHeaderViewToNavigationBarTransitionView.swift
//  stretchy-header-to-navigation-bar
//
//  Created by Antoine Barre on 3/9/20.
//  Copyright © 2020 Pomanks. All rights reserved.
//

import UIKit

class StretchyHeaderViewToNavigationBarTransitionView: UIView, StretchyHeaderViewToNavigationBarTransitionCapable {

    // MARK: - Members

    var navigationUnderlayHeight: CGFloat

    var heightRatio: CGFloat {
        return 2 / 3
    }

    private(set) lazy var multiplier: CGFloat = { 1 / heightRatio }()

    private(set) lazy var navigationUnderlayGradientView: GradientView = {
        let view = GradientView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.configureNavigationBackground()

        return view
    }()

    private(set) lazy var imageView: UIImageView = {
        let image = UIImage(named: "background")
        let imageView = UIImageView(image: image)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill // This is required for the stretchy effect
        imageView.clipsToBounds = true

        return imageView
    }()

    private(set) lazy var visualEffectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: effect)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = .zero

        return view
    }()

    // MARK: - Initializers

    convenience init(navigationUnderlayHeight: CGFloat) {
        self.init(frame: .zero, navigationUnderlayHeight: navigationUnderlayHeight)
    }

    init(frame: CGRect, navigationUnderlayHeight: CGFloat) {
        self.navigationUnderlayHeight = navigationUnderlayHeight

        super.init(frame: frame)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
}

// MARK: - Helpers

private extension StretchyHeaderViewToNavigationBarTransitionView {

    func configureHierarchy() {
        preservesSuperviewLayoutMargins = true

        backgroundColor = UIColor(white: 1, alpha: 0.2)

        addSubview(imageView)
        addSubview(navigationUnderlayGradientView)
        addSubview(visualEffectView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            navigationUnderlayGradientView.topAnchor.constraint(equalTo: topAnchor),
            navigationUnderlayGradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationUnderlayGradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationUnderlayGradientView.heightAnchor.constraint(equalToConstant: navigationUnderlayHeight),

//            overlayView.topAnchor.constraint(equalTo: topAnchor),
//            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),

            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
