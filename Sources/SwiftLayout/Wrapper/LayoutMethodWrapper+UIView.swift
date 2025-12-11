//
//  LayoutMethodWrapper+UIView.swift
//
//
//  Created by oozoofrog on 2022/03/13.
//

import UIKit

// MARK: - Public UIView API
public extension LayoutMethodWrapper where Base: UIView {

    /// Creates a ``ViewLayout`` containing this view with the specified anchors.
    ///
    /// ``Anchors`` express **NSLayoutConstraint** and can be applied through this method.
    /// ```swift
    /// subView.sl.anchors {
    ///     Anchors.top.equalTo(rootView, constant: 10)
    ///     Anchors.centerX.equalTo(rootView)
    ///     Anchors.size.equalTo(rootView).multiplier(0.5)
    /// }
    ///
    /// // Equivalent to:
    /// NSLayoutConstraint.activate([
    ///     subView.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 10),
    ///     subView.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
    ///     subView.widthAnchor.constraint(equalTo: rootView.widthAnchor, multiplier: 0.5),
    ///     subView.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.5)
    /// ])
    /// ```
    ///
    /// - Parameter build: An ``AnchorsBuilder`` closure that creates ``Anchors`` to be applied to this layout.
    /// - Returns: A ``ViewLayout`` that wraps this view and contains the anchors.
    func anchors(@AnchorsBuilder _ build: () -> Anchors) -> ViewLayout<Base, EmptyLayout> {
        ViewLayout(self.base, sublayout: EmptyLayout(), anchors: build())
    }

    /// Creates a ``ViewLayout`` containing the sublayouts of this view.
    ///
    /// Sublayouts contained within the builder block are added to the view hierarchy through `addSubview(_:)`.
    /// ```swift
    /// rootView.sl.sublayout {
    ///     childView.sl.anchors {
    ///         Anchors.allSides.equalToSuper()
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter build: A ``LayoutBuilder`` closure that creates sublayouts of this view.
    /// - Returns: A ``ViewLayout`` that wraps this view and contains sublayouts.
    func sublayout<LayoutType: Layout>(@LayoutBuilder _ build: () -> LayoutType) -> ViewLayout<Base, LayoutType> {
        ViewLayout(self.base, sublayout: build())
    }

    /// Wraps this view with a layout type eraser.
    ///
    /// - Returns: An ``AnyLayout`` wrapping this layout.
    func eraseToAnyLayout() -> AnyLayout {
        AnyLayout(ViewLayout(self.base, sublayout: EmptyLayout()))
    }

    /// Creates a ``ViewLayout`` with an action to perform before every activation, including updates.
    ///
    /// ```swift
    /// var layout: some Layout {
    ///     UILabel().sl.onActivate { label in
    ///         label.backgroundColor = .blue
    ///         label.text = "hello"
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter perform: A closure to execute before activation.
    /// - Returns: A ``ViewLayout`` with the onActivate action added.
    func onActivate(_ perform: @escaping (Base) -> Void) -> ViewLayout<Base, EmptyLayout> {
        ViewLayout(self.base, sublayout: EmptyLayout(), onActivate: perform)
    }

    /// Sets the view's `accessibilityIdentifier`.
    ///
    /// ```swift
    /// let label = UILabel().sl.identifying("myLabel")
    /// ```
    ///
    /// - Parameter accessibilityIdentifier: A string containing the identifier of the element.
    /// - Returns: The view itself with the accessibilityIdentifier applied.
    func identifying(_ accessibilityIdentifier: String) -> Base {
        self.base.accessibilityIdentifier = accessibilityIdentifier
        return self.base
    }
}
