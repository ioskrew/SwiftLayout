//
//  LayoutMethodWrapper+UILayoutGuide.swift
//
//
//  Created by oozoofrog on 2022/03/13.
//

import SwiftLayoutPlatform

// MARK: - Public SLLayoutGuide API
public extension LayoutMethodWrapper where Base: SLLayoutGuide {

    /// Creates a ``GuideLayout`` containing this layout guide with the specified anchors.
    ///
    /// ``Anchors`` express **NSLayoutConstraint** and can be applied through this method.
    /// ```swift
    /// layoutGuide.sl.anchors {
    ///     Anchors.top.equalTo(rootView, constant: 10)
    ///     Anchors.centerX.equalTo(rootView)
    ///     Anchors.size.equalTo(rootView).multiplier(0.5)
    /// }
    /// ```
    ///
    /// - Parameter build: An ``AnchorsBuilder`` closure that creates ``Anchors`` to be applied to this layout.
    /// - Returns: A ``GuideLayout`` that wraps this layout guide and contains the anchors.
    func anchors(@AnchorsBuilder _ build: () -> Anchors) -> GuideLayout<Base> {
        GuideLayout(self.base, anchors: build())
    }

    /// Wraps this layout guide with a layout type eraser.
    ///
    /// - Returns: An ``AnyLayout`` wrapping this layout.
    func eraseToAnyLayout() -> AnyLayout {
        AnyLayout(GuideLayout(self.base))
    }

    /// Sets the layout guide's `identifier` and returns a layout for method chaining.
    ///
    /// ```swift
    /// // Can be used in sublayout builders
    /// root.sl.sublayout {
    ///     guide.sl.identifying("myGuide")
    /// }
    ///
    /// // Supports method chaining
    /// guide.sl.identifying("myGuide").anchors {
    ///     Anchors.allSides.equalToSuper()
    /// }
    /// ```
    ///
    /// - Parameter identifier: A string that uniquely identifies the layout guide.
    /// - Returns: A ``GuideLayout`` for method chaining and use in layout builders.
    func identifying(_ identifier: String) -> GuideLayout<Base> {
        SwiftLayoutPlatformHelper.setGuideIdentifier(self.base, identifier)
        return GuideLayout(self.base)
    }
}
