//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import UIKit

@MainActor
public protocol Layout {
    func layoutComponents(superview: UIView?, option: LayoutOption) -> [LayoutComponent]

    func layoutWillActivate()
    func layoutDidActivate()
}

extension Layout {

    ///
    /// Activate this layout.
    ///
    /// - Parameter forceLayout: If `true`, forces immediate layout updates by calling `setNeedsLayout()` and `layoutIfNeeded()` on the root view.
    /// - Returns: A ``Activation`` instance, which you use when you update or deactivate layout.
    ///
    public func active(forceLayout: Bool = false) -> Activation {
        Activator.active(layout: self, forceLayout: forceLayout)
    }

    ///
    /// Update layout changes from the activation of the previously activated layout.
    ///
    /// - Parameter activation: The activation of the previously activated layout. It is used to identify changes in layout.
    /// - Parameter forceLayout: If `true`, forces immediate layout updates by calling `setNeedsLayout()` and `layoutIfNeeded()` on the root view.
    /// - Returns: A ``Activation`` instance, which you use when you update or deactivate layout.
    ///
    public func update(fromActivation activation: Activation, forceLayout: Bool = false) -> Activation {
        Activator.update(layout: self, fromActivation: activation, forceLayout: forceLayout)
    }

    ///
    /// Activate this layout permanently.
    /// Until the view is released according to the lifecycle of the app
    ///
    /// - Parameter forceLayout: If `true`, forces immediate layout updates by calling `setNeedsLayout()` and `layoutIfNeeded()` on the root view.
    ///
    public func finalActive(forceLayout: Bool = false) {
        Activator.finalActive(layout: self, forceLayout: forceLayout)
    }

    ///
    /// Wraps this layout with a type eraser.
    ///
    /// - Returns: An ``AnyLayout`` wrapping this layout.
    ///
    public func eraseToAnyLayout() -> AnyLayout {
        AnyLayout(self)
    }
}
