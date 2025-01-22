//
//  LayoutMethodWrapper.swift
//  
//
//  Created by oozoofrog on 2022/03/13.
//

import UIKit

@MainActor
public struct LayoutMethodWrapper<Base: LayoutMethodAccessible> {
    let base: Base
}

public extension LayoutMethodWrapper where Base: UIView {

    ///
    /// Create a ``ViewLayout`` containing this view and the sublayouts and add anchors coordinator to this layout
    ///
    /// ``Anchors`` express **NSLayoutConstraint** and can be applied through this method.
    /// ```swift
    /// // The constraint of the view can be expressed as follows.
    ///
    /// subView.sl.anchors {
    ///     Anchors(.top).equalTo(rootView, constant: 10)
    ///     Anchors(.centerX).equalTo(rootView)
    ///     Anchors(.width, .height).equalTo(rootView).setMultiplier(0.5)
    /// }
    ///
    /// // The following code performs the same role as the code above.
    ///
    /// NSLayoutConstraint.activate([
    ///     subView.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 10),
    ///     subView.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
    ///     subView.widthAnchor.constraint(equalTo: rootView.widthAnchor, multiplier: 0.5),
    ///     subView.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.5)
    /// ])
    /// ```
    ///
    /// - Parameter build: A ``AnchorsBuilder`` that  create ``Anchors`` to be applied to this layout
    /// - Returns: An ``ViewLayout`` that wraps this view and contains the anchors  coordinator.
    ///
    func anchors(@AnchorsBuilder _ build: () -> Anchors) -> ViewLayout<Base, EmptyLayout> {
        ViewLayout(self.base, sublayout: EmptyLayout(), anchors: build())
    }

    ///
    /// Create a ``ViewLayout`` containing the sublayouts of this view.
    ///
    /// Sublayouts contained within the builder block are added to the view hierarchy through **addSubview(_:)** to the view.
    /// ```swift
    /// // The hierarchy of views can be expressed as follows,
    /// // and means that UILabel is a subview of UIView.
    ///
    /// UIView().sl.sublayout {
    ///     UILabel()
    /// }
    /// ```
    ///
    /// - Parameter build: A ``LayoutBuilder`` that  create sublayouts of this view.
    /// - Returns: An ``ViewLayout`` that wraps this view and contains sublayouts .
    ///
    func sublayout<LayoutType: Layout>(@LayoutBuilder _ build: () -> LayoutType) -> ViewLayout<Base, LayoutType> {
        ViewLayout(self.base, sublayout: build())
    }

    ///
    /// Wraps this view with a layout type eraser.
    ///
    /// - Returns: An ``AnyLayout`` wrapping this layout.
    ///
    func eraseToAnyLayout() -> AnyLayout {
        AnyLayout(ViewLayout(self.base, sublayout: EmptyLayout()))
    }

    ///
    /// Create a ``ViewLayout``  for this view that includes an action to always perform before every activation, including updates.
    ///
    /// ```swift
    /// // Create an instant view within the layout block
    /// // and modify the properties of the view as follows
    ///
    /// var layout: some Layout {
    ///     UILabel().sl.onActivate { view in
    ///         view.backgroundColor = .blue
    ///         view.text = "hello"
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter perform: A perform block for new layout.
    /// - Returns:  An ``ViewLayout`` with onActivate action added
    ///
    func onActivate(_ perform: @escaping (Base) -> Void) -> ViewLayout<Base, EmptyLayout> {
        ViewLayout(self.base, sublayout: EmptyLayout(), onActivate: perform)
    }

    ///
    /// Set its **accessibilityIdentifier**.
    ///
    /// - Parameter accessibilityIdentifier: A string containing the identifier of the element.
    /// - Returns: The view itself with the accessibilityIdentifier applied
    ///
    func identifying(_ accessibilityIdentifier: String) -> Base {
        self.base.accessibilityIdentifier = accessibilityIdentifier
        return self.base
    }
}
