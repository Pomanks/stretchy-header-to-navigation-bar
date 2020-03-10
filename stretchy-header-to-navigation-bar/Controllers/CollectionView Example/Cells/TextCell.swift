//
//  TextCell.swift
//  stretchy-header-to-navigation-bar
//
//  Created by Antoine Barre on 3/10/20.
//  Copyright © 2020 Pomanks. All rights reserved.
//

// Imported from : https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/using_collection_view_compositional_layouts_and_diffable_data_sources

import UIKit

class TextCell: UICollectionViewCell {

    static let reuseIdentifier = "text-cell-reuse-identifier"

    // MARK: - Members

    let label = UILabel()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextCell {

    func configure() {
        contentView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
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
