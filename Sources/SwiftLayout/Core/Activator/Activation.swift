//
//  Activation.swift
//
//
//  Created by aiden_h on 2022/02/16.
//

import SwiftLayoutPlatform

/// Represents the active state of a layout, including view hierarchy and constraints.
///
/// `Activation` is returned when you call ``Layout/active(mode:)`` and holds references
/// to the activated constraints and view hierarchy information. Use it to:
/// - Update the layout when state changes
/// - Deactivate the layout when no longer needed
/// - Access views or layout guides by their identifiers
/// - Update constraint constants dynamically
///
/// ## Overview
///
/// ```swift
/// // Activate a layout and store the activation
/// var activation = layout.active()
///
/// // Update when state changes
/// activation = layout.update(fromActivation: activation)
///
/// // Access views by identifier
/// let myView = activation.viewForIdentifier("myView")
///
/// // Update constraints dynamically
/// activation.anchors("headerHeight").update(constant: 200)
///
/// // Deactivate when done
/// activation.deactive()
/// ```
public final class Activation: Hashable {
    var hierarchyInfos: [HierarchyInfo]
    var constraints: Set<WeakConstraint>

    @MainActor
    var needsUpdateLayout: Bool = false

    convenience init() {
        self.init(hierarchyInfos: [], constraints: .init())
    }

    init(hierarchyInfos: [HierarchyInfo], constraints: Set<WeakConstraint>) {
        self.hierarchyInfos = hierarchyInfos
        self.constraints = constraints
    }
}

extension Activation {
    @MainActor
    public func deactive() {
        let hierarchyInfos = self.hierarchyInfos
        let constraints = self.constraints

        Deactivator().deactivate(hierarchyInfo: hierarchyInfos, constraints: constraints)
    }

    @MainActor
    public func viewForIdentifier(_ identifier: String) -> SLView? {
        hierarchyInfos.first(where: { $0.identifier == identifier })?.node.baseObject as? SLView
    }

    @MainActor
    public func layoutGuideForIdentifier(_ identifier: String) -> SLLayoutGuide? {
        hierarchyInfos.first(where: { $0.identifier == identifier })?.node.baseObject as? SLLayoutGuide
    }

    /// Returns an updater scoped to constraints carrying the given identifier.
    ///
    /// The returned instance retains this activation and re-evaluates the predicate
    /// on every call, so it is safe to store the updater for later use.
    ///
    /// ```swift
    /// let updater = activation.anchors("flag-anchor", attribute: .bottom)
    /// updater.update(constant: -5, priority: .defaultHigh)
    /// ```
    @MainActor
    public func anchors(
        _ identifier: String,
        predicate: ConstraintUpdater.Predicate? = nil
    ) -> ConstraintUpdater {
        ConstraintUpdater(activation: self, identifier: identifier, predicate: predicate)
    }

    @MainActor
    public func anchors(
        _ identifier: String,
        attribute: NSLayoutConstraint.Attribute
    ) -> ConstraintUpdater {
        anchors(identifier, predicate: { $0.attribute == attribute })
    }

    public func store<C: RangeReplaceableCollection>(_ store: inout C) where C.Element == Activation {
        store.append(self)
    }

    public func store(_ store: inout Set<Activation>) {
        store.insert(self)
    }
}

// MARK: - Hashable
extension Activation {
    public static func == (lhs: Activation, rhs: Activation) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(hierarchyInfos)
        hasher.combine(constraints)
    }
}
