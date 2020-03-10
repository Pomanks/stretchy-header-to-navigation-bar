//
//  SectionBackgroundDecorationView.swift
//  stretchy-header-to-navigation-bar
//
//  Created by Antoine Barre on 3/10/20.
//  Copyright © 2020 Pomanks. All rights reserved.
//

import UIKit

final class SectionBackgroundDecorationView: UICollectionReusableView {

    static let elementKind: String = "SectionBackgroundDecorationViewElementKind"

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SectionBackgroundDecorationView {

    func configureHierarchy() {
        backgroundColor = .systemBackground
    }
}
