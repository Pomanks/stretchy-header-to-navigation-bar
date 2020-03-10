//
//  UIColor+Helpers.swift
//  stretchy-header-to-navigation-bar
//
//  Created by Antoine Barre on 3/9/20.
//  Copyright © 2020 Pomanks. All rights reserved.
//

import UIKit

extension UIColor {

    public var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return (hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    public func withSaturationUpdated(to newValue: CGFloat) -> UIColor {
        var newHsba = hsba

        newHsba.saturation = newValue

        return UIColor(hue: newHsba.hue, saturation: newHsba.saturation, brightness: newHsba.brightness, alpha: newHsba.alpha)
    }
}
