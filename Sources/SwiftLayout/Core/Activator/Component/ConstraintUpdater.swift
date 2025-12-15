//
//  ConstraintUpdater.swift
//

import SwiftLayoutPlatform

/// Provides identifier-scoped updates over constraints owned by an activation.
///
/// Each updater retains its activation and stores a single predicate that gets
/// re-evaluated on every call, so it is safe to store the updater for later use.
@MainActor
public struct ConstraintUpdater {
    public typealias Predicate = (ConstraintDescriptor) -> Bool

    private weak var activation: Activation?
    private let identifier: String
    private let predicate: Predicate?

    init(activation: Activation, identifier: String, predicate: Predicate?) {
        self.activation = activation
        self.identifier = identifier
        self.predicate = predicate
    }

    /// Updates the constant and/or priority of every constraint selected by the identifier/predicate pair.
    ///
    /// - Parameters:
    ///   - constant: Replacement constant. Pass `nil` to keep the current value.
    ///   - priority: Replacement priority. Pass `nil` to keep the current value.
    public func update(
        constant: CGFloat? = nil,
        priority: SLLayoutPriority? = nil
    ) {
        guard let activation else { return }

        guard constant != nil || priority != nil else { return }

        let selectedConstraints: [WeakConstraint] = activation.constraints.filter {
            guard let constraint = $0.origin else { return false }
            let matchesId = constraint.identifier == identifier
            let matchesPredicate = predicate?(ConstraintDescriptor(constraint: constraint)) ?? true
            return matchesId && matchesPredicate
        }

        guard !selectedConstraints.isEmpty else { return }

        for weakConstraint in selectedConstraints {
            guard let constraint = weakConstraint.origin else { continue }

            activation.constraints.remove(weakConstraint)

            if let constant {
                constraint.constant = constant
            }

            if let priority {
                constraint.priority = priority
            }

            activation.constraints.insert(WeakConstraint(origin: constraint))
        }
    }
}

extension ConstraintUpdater {

    @MainActor
    public struct ConstraintDescriptor {
        private let constraint: NSLayoutConstraint

        init(constraint: NSLayoutConstraint) {
            self.constraint = constraint
        }

        public var attribute: NSLayoutConstraint.Attribute { constraint.firstAttribute }
        public var relation: NSLayoutConstraint.Relation { constraint.relation }
        public var firstItem: AnyObject? { constraint.firstItem as AnyObject? }
        public var secondItem: AnyObject? { constraint.secondItem as AnyObject? }
        public var constant: CGFloat { constraint.constant }
        public var priority: SLLayoutPriority { constraint.priority }
        public var identifier: String? { constraint.identifier }
    }
}
