//
//  Layoutable.swift
//
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation

@MainActor
public protocol Layoutable: AnyObject, LayoutMethodAccessible {
    associatedtype LayoutBody: Layout

    /// Stores the current activation state of the layout.
    ///
    /// This property holds the ``Activation`` instance returned from layout activation,
    /// which is used to track and update the layout state.
    var activation: Activation? { get set }

    /// The declarative layout definition for this view.
    ///
    /// Define your view hierarchy and constraints using ``LayoutBuilder`` DSL syntax.
    @LayoutBuilder var layout: LayoutBody { get }
}

/// Specifies when and how layout updates should be applied.
///
/// Layout updates include rebuilding the view hierarchy (adding/removing subviews)
/// and activating/deactivating constraints based on the current `layout` definition.
public enum LayoutUpdateMode {
    /// Defers the layout update to the next run loop cycle.
    ///
    /// Multiple deferred updates within the same run loop cycle
    /// are coalesced into a single update, improving performance
    /// when multiple layout properties change in succession.
    case deferred

    /// Applies the layout update immediately.
    ///
    /// Updates view hierarchy and constraints synchronously
    /// but does not trigger a layout pass.
    case immediate

    /// Applies the layout update immediately with a forced layout pass.
    ///
    /// After updating view hierarchy and constraints,
    /// calls `setNeedsLayout()` and `layoutIfNeeded()` on affected views
    /// to calculate frames immediately.
    case forced
}

public extension LayoutMethodWrapper where Base: Layoutable {
    /// Updates the layout with the specified mode.
    ///
    /// This method updates the entire view hierarchy including
    /// parent-child relationships and constraints.
    ///
    /// ```swift
    /// // Deferred update (batched, next run loop)
    /// sl.updateLayout(.deferred)
    ///
    /// // Immediate update
    /// sl.updateLayout(.immediate)
    ///
    /// // Forced update (with layout pass)
    /// sl.updateLayout(.forced)
    /// ```
    func updateLayout(_ mode: LayoutUpdateMode = .immediate) {
        switch mode {
        case .deferred:
            setNeedsUpdateLayout()
        case .immediate:
            performUpdateLayout(mode: .normal)
        case .forced:
            performUpdateLayout(mode: .forced)
        }
    }
}

private extension LayoutMethodWrapper where Base: Layoutable {
    func setNeedsUpdateLayout() {
        if base.activation == nil {
            base.activation = Activation()
        }

        guard base.activation?.needsUpdateLayout == false else { return }
        base.activation?.needsUpdateLayout = true

        nonisolated(unsafe) weak var weakBase = base
        RunLoop.main.perform {
            MainActor.assumeIsolated {
                weakBase?.sl.updateLayoutIfNeeded()
            }
        }
    }

    func updateLayoutIfNeeded() {
        guard
            let activation = base.activation,
            activation.needsUpdateLayout
        else {
            return
        }

        activation.needsUpdateLayout = false
        performUpdateLayout(mode: .normal)
    }

    func performUpdateLayout(mode: ActivateMode) {
        base.activation = Activator.update(
            layout: base.layout,
            fromActivation: base.activation ?? Activation(),
            mode: mode
        )
    }
}
