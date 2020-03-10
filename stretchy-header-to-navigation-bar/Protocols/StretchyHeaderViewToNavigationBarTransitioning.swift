//
//  StretchyHeaderViewToNavigationBarTransitioning.swift
//  stretchy-header-to-navigation-bar
//
//  Created by Antoine Barre on 3/9/20.
//  Copyright © 2020 Pomanks. All rights reserved.
//

import UIKit

protocol StretchyHeaderViewToNavigationBarTransitioning: UIViewController, UIScrollViewDelegate {

    var animator: UIViewPropertyAnimator? { get set }
    var transitionTopConstraint: NSLayoutConstraint! { get set }
    var transitionHeightConstraint: NSLayoutConstraint! { get set }
    var overlayBottomConstraint: NSLayoutConstraint! { get set }
    var overlayHeightConstraint: NSLayoutConstraint! { get set }

    var overlayOffset: CGPoint { get } /// How much it will be offset from `transitionView`'s bottom, if any.
    var scrollView: UIScrollView { get }
    var transitionView: StretchyHeaderViewToNavigationBarTransitionCapable { get }
    var overlayView: OverlayViewTransitionCapable { get }

    func configureScrollViewHierarchy()
    func scrollViewWillLayoutSubviews()
    func scrollViewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    func scrollViewDidPerformTransition()
}

// MARK: - Default Methods Implementation

extension StretchyHeaderViewToNavigationBarTransitioning {

    /**
     Configures the properties for the animation to happen.

     This method should be called inside `viewDidLoad()`.
     */
    func configureScrollViewHierarchy() {
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.preservesSuperviewLayoutMargins = true

        transitionView.layer.zPosition = -1

        scrollView.addSubview(transitionView)
        scrollView.addSubview(overlayView)

        animator = UIViewPropertyAnimator()
        animator?.startAnimation()
        animator?.pauseAnimation()

        // Constants are set later…
        transitionTopConstraint = transitionView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        overlayBottomConstraint = overlayView.bottomAnchor.constraint(equalTo: scrollView.topAnchor)

        NSLayoutConstraint.activate([
            transitionTopConstraint,

            transitionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transitionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            overlayBottomConstraint
        ])
    }

    /**
     Updates both `contentInset.top` and `contentOffset` of your `scrollView` to match you `view`'s `width`.
     This will also ensure you header's constraints (`heightAnchor` / `topAnchor`) are updated with the correct values.

     This method should be called inside `viewWillLayoutSubviews()`.
     */
    func scrollViewWillLayoutSubviews() {
        guard transitionHeightConstraint == nil, overlayHeightConstraint == nil else {
            return
        }
        let effectiveHeight = headerHeight

        transitionHeightConstraint = transitionView.heightAnchor.constraint(equalToConstant: effectiveHeight)
        transitionHeightConstraint.priority = .init(rawValue: 999)

        overlayHeightConstraint = overlayView.heightAnchor.constraint(equalToConstant: effectiveHeight)

        NSLayoutConstraint.activate([
            transitionHeightConstraint,
            overlayHeightConstraint
        ])
        updateHeaderViews()
        updateScrollView()
    }

    /**
     Ensures the `transitionView` still fits your requirements and adapts to any new size.

     This method should be called inside `viewWillTransition(to:, with:)`.

     - Parameters:
        - size:         The new size for the container’s view.
        - coordinator:  The transition coordinator object managing the size change. You can use this object to animate your changes or get information about the transition that is in progress.

     */
    func scrollViewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateTransitionView(with: size)
            self?.updateOverlayHeaderView(with: size)
            self?.updateScrollView()
        })
    }

    /**
     This method performs all the transition logic.

     This method should be called inside `scrollViewDidScroll(_:)`.
     */

    func scrollViewDidPerformTransition() {
        let currentHeight = headerHeight

        updateNavigationBarAppearance()
        updateHeaderViews()

        performFirstTransition(after: .twoThirds(of: currentHeight))
        performSecondTransition(after: .oneThird(of: currentHeight))
    }
}

// MARK: - Helpers

private extension StretchyHeaderViewToNavigationBarTransitioning {

    var headerHeight: CGFloat {
        return view.bounds.width * transitionView.multiplier
    }

    var heightConstant: CGFloat {
        return transitionHeightConstraint.constant
    }

    var contentOffset: CGPoint {
        return scrollView.contentOffset
    }

    func updateNavigationBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()

        navigationBarAppearance.titleTextAttributes = [
            .font: .preferredFont(forTextStyle: .headline) as UIFont,
            .foregroundColor: .label as UIColor
        ]
        if -contentOffset.y <= navigationControllerHeight {
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.shadowColor = nil
            navigationBarAppearance.shadowImage = nil

            navigationController?.navigationBar.tintColor = .systemOrange
        } else {
            navigationBarAppearance.configureWithTransparentBackground()
        }
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
    }

    func updateScrollView() {
        let newConstant = heightConstant + overlayOffset.y

        scrollView.contentInset.top = newConstant
        scrollView.contentOffset = CGPoint(x: .zero, y: -newConstant)
        scrollView.verticalScrollIndicatorInsets.top = newConstant - scrollView.safeAreaInsets.top
    }

    func updateHeaderViews() {
        updateTransitionView()
        updateOverlayHeaderView()
    }

    func updateTransitionView(with size: CGSize? = nil) {
        let currentHeight = headerHeight
        let newConstant = size == nil ? contentOffset.y : size!.width * transitionView.multiplier
        let overlayVerticalOffset = overlayOffset.y
        let relativeVerticalOffset = currentHeight + newConstant + overlayVerticalOffset

        if relativeVerticalOffset <= .zero {
            let newHeight = -newConstant - overlayVerticalOffset

            transitionTopConstraint.constant = newConstant
            transitionHeightConstraint.constant = newHeight
        } else {
            let additionalOffset = (relativeVerticalOffset / currentHeight) * 65

            transitionTopConstraint.constant = newConstant - additionalOffset
        }
    }

    func updateOverlayHeaderView(with size: CGSize? = nil) {
        if let size = size {
            let newConstant = size.width * transitionView.multiplier

            overlayHeightConstraint.constant = newConstant
        }
    }

    // MARK: Transition (Part 1)

    func performFirstTransition(after threshold: CGFloat) {
        let alpha: CGFloat = 1 - calculateAlpha(for: threshold)

        transitionView.navigationUnderlayGradientView.alpha = alpha

//                overlayHeaderView.alpha = alpha
    }

    func updateNavigationBarTintColorAlpha(with alpha: CGFloat) {
        let tintColor: UIColor = alpha == .zero ? .white : UIColor.systemOrange.withSaturationUpdated(to: alpha)

        navigationController?.navigationBar.tintColor = tintColor
    }

    // MARK: Transition (Part 2)

    func performSecondTransition(after threshold: CGFloat) {
        let alpha: CGFloat = calculateAlpha(for: threshold)
        let reversedAlpha = 1 - alpha

        transitionView.imageView.alpha = reversedAlpha
        transitionView.visualEffectView.alpha = alpha

        overlayView.alpha = reversedAlpha

        updateStatusBarStyle(with: alpha)
        updateNavigationBarTintColorAlpha(with: alpha)
        updateNavigationItemAlpha(to: alpha)
    }

    func updateStatusBarStyle(with fractionComplete: CGFloat) {
        animator?.addAnimations { [weak self] in
//            self?.rootViewController?.statusBarStyle = fractionComplete >= 0.5 ? .default : .lightContent
        }
        animator?.fractionComplete = fractionComplete
    }

    func updateNavigationItemAlpha(to alpha: CGFloat) {
        navigationItem.titleView?.alpha = alpha
    }

    func calculateAlpha(for threshold: CGFloat) -> CGFloat {
        let delta: CGFloat = 26 + navigationControllerHeight // Matches half the Large Title extra space
        //        let threshold: CGFloat = .oneThird(of: headerHeight) // The point where our transition will start
        let effectiveNavigationOffsetY = threshold + delta + contentOffset.y // The offset matching our navigation's height

        return .fractionComplete(from: effectiveNavigationOffsetY / threshold)
    }
}

extension CGFloat {

    static func fractionComplete(from value: CGFloat) -> Self {
        return Swift.max(.zero, Swift.min(value, 1.0))
    }

    static func oneThird(of value: CGFloat) -> Self {
        return value / CGFloat(3)
    }

    static func twoThirds(of value: CGFloat) -> Self {
        return value - .oneThird(of: value)
    }
}
