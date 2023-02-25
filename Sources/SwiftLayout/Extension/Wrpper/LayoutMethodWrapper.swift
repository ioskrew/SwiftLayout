//
//  LayoutMethodWrapper.swift
//  
//
//  Created by oozoofrog on 2022/03/13.
//

import UIKit

public struct LayoutMethodWrapper<Base: LayoutBase> {
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
    func anchors(@AnchorsBuilder _ build: () -> Anchors) -> ViewLayout<Base> {
        ViewLayout(self.base, anchors: build())
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
    func sublayout<LayoutType: Layout>(@LayoutBuilder _ build: () -> LayoutType) -> ViewLayout<Base> {
        ViewLayout(self.base, sublayouts: [build()])
    }

    ///
    /// Wraps this view with a layout type eraser.
    ///
    /// - Returns: An ``AnyLayout`` wrapping this layout.
    ///
    func eraseToAnyLayout() -> AnyLayout {
        AnyLayout(ViewLayout(self.base))
    }

    ///
    /// Provides a block that can change the properties of the view within the layout block.
    ///
    /// ```swift
    /// // Create an instant view within the layout block
    /// // and modify the properties of the view as follows
    ///
    /// var layout: some Layout {
    ///     UILabel().sl.config { view in
    ///         view.backgroundColor = .blue
    ///         view.text = "hello"
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter config: A configuration block for this view.
    /// - Returns: The view itself with the configuration applied
    ///
    func config(_ config: (Base) -> Void) -> Base {
        config(self.base)
        return self.base
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
