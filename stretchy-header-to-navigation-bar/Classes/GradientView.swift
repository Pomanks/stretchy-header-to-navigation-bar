//
//  GradientView.swift
//  stretchy-header-to-navigation-bar
//
//  Created by Antoine Barre on 3/9/20.
//  Copyright © 2020 Pomanks. All rights reserved.
//

import UIKit

final class GradientView: UIView {

    // MARK: - Overrides

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    // MARK: - Members

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    func configureDefaultBackground(locations: [NSNumber]? = nil) {
        let colors: [UIColor] = [
            .clear,
            .darkGray
        ]
        configureGradient(with: colors, locations: locations)
    }

    func configureNavigationBackground() {
        let colors: [UIColor] = [
            UIColor.black.withAlphaComponent(0.7),
            .clear
        ]
        configureGradient(with: colors, locations: nil)
    }
}

// MARK: - Helpers

private extension GradientView {

    func configureGradient(with colors: [UIColor], locations: [NSNumber]?) {
        guard let layer = layer as? CAGradientLayer else {
            return
        }
        layer.colors = colors.map { $0.cgColor }
        layer.locations = locations
    }
}
