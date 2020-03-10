//
//  StretchyHeaderViewToNavigationBarTransitionCapable.swift
//  stretchy-header-to-navigation-bar
//
//  Created by Antoine Barre on 3/9/20.
//  Copyright © 2020 Pomanks. All rights reserved.
//

import UIKit

protocol StretchyHeaderViewToNavigationBarTransitionCapable: UIView {

    var multiplier: CGFloat { get }

    var navigationUnderlayGradientView: GradientView { get }
    var imageView: UIImageView { get }
    var visualEffectView: UIVisualEffectView { get }
}
