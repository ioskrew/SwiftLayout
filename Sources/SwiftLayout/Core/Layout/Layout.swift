//
//  Layout.swift
//
//
//  Created by oozoofrog on 2022/01/26.
//

import SwiftLayoutPlatform

@MainActor
public protocol Layout {
    func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent]

    func layoutWillActivate()
    func layoutDidActivate()
}

extension Layout {

    ///
    /// Activate this layout.
    ///
    /// - Parameter mode: The activation mode. Use `.normal` (default) for view hierarchy and constraints only,
    ///   or `.forced` to also trigger layout pass.
    /// - Returns: A ``Activation`` instance, which you use when you update or deactivate layout.
    ///
    public func active(mode: ActivateMode = .normal) -> Activation {
        Activator.active(layout: self, mode: mode)
    }

    ///
    /// Update layout changes from the activation of the previously activated layout.
    ///
    /// - Parameter activation: The activation of the previously activated layout. It is used to identify changes in layout.
    /// - Parameter mode: The activation mode. Use `.normal` (default) for view hierarchy and constraints only,
    ///   or `.forced` to also trigger layout pass.
    /// - Returns: A ``Activation`` instance, which you use when you update or deactivate layout.
    ///
    public func update(fromActivation activation: Activation, mode: ActivateMode = .normal) -> Activation {
        Activator.update(layout: self, fromActivation: activation, mode: mode)
    }

    ///
    /// Activate this layout permanently.
    /// Until the view is released according to the lifecycle of the app
    ///
    /// - Parameter mode: The activation mode. Use `.normal` (default) for view hierarchy and constraints only,
    ///   or `.forced` to also trigger layout pass.
    ///
    public func finalActive(mode: ActivateMode = .normal) {
        Activator.finalActive(layout: self, mode: mode)
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
