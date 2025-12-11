//
//  Activation.swift
//
//
//  Created by aiden_h on 2022/02/16.
//

import UIKit

public final class Activation: Hashable {
    var hierarchyInfos: [HierarchyInfo]
    var constraints: Set<WeakConstraint>

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
    public func viewForIdentifier(_ identifier: String) -> UIView? {
        hierarchyInfos.first(where: { $0.identifier == identifier })?.node.baseObject as? UIView
    }

    @MainActor
    public func layoutGuideForIdentifier(_ identifier: String) -> UILayoutGuide? {
        hierarchyInfos.first(where: { $0.identifier == identifier })?.node.baseObject as? UILayoutGuide
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
