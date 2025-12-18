//
//  Layout.swift
//
//
//  Created by oozoofrog on 2022/01/26.
//

import SwiftLayoutPlatform

/// A protocol that represents a declarative layout structure.
///
/// `Layout` is the fundamental building block of SwiftLayout's DSL. It defines a tree structure
/// of views and their constraints that can be activated, updated, or deactivated.
///
/// ## Overview
///
/// You typically don't conform to `Layout` directly. Instead, use the built-in layout types
/// created through ``LayoutBuilder`` and the `.sl` extension methods:
///
/// ```swift
/// @LayoutBuilder var layout: some Layout {
///     parentView.sl.sublayout {
///         childView.sl.anchors {
///             Anchors.allSides.equalToSuper()
///         }
///     }
/// }
/// ```
///
/// ## Activation
///
/// Use the following methods to apply layouts:
/// - ``active(forceLayout:)`` - Activates and returns an ``Activation`` for later updates
/// - ``finalActive(forceLayout:)`` - Activates permanently without returning activation state
/// - ``update(fromActivation:forceLayout:)`` - Updates an existing activation with changes
///
/// ## Built-in Layout Types
///
/// - ``ViewLayout`` - Wraps a view with optional anchors and sublayouts
/// - ``GuideLayout`` - Wraps a layout guide with anchors
/// - ``GroupLayout`` - Groups multiple layouts with shared options
/// - ``AnyLayout`` - Type-erased layout wrapper
@MainActor
public protocol Layout {
    /// Returns the layout components for activation.
    ///
    /// - Parameters:
    ///   - superview: The parent view for this layout's root elements.
    ///   - option: Layout options affecting how views are added.
    /// - Returns: An array of layout components to be processed.
    func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent]

    /// Called before the layout is activated.
    ///
    /// Override this method to perform setup before views are added to the hierarchy.
    func layoutWillActivate()

    /// Called after the layout is activated.
    ///
    /// Override this method to perform additional setup after constraints are activated.
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
