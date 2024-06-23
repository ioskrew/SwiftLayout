//
//  Activation.swift
//
//
//  Created by aiden_h on 2022/02/16.
//

import UIKit


public final class Activation: Hashable {
    var viewInfos: [ViewInformation]
    var constraints: Set<WeakConstraint>
    
    convenience init() {
        self.init(viewInfos: .init(), constraints: .init())
    }

    init(viewInfos: [ViewInformation], constraints: Set<WeakConstraint>) {
        self.viewInfos = viewInfos
        self.constraints = constraints
    }

    deinit {
        // TODO: Need a way to properly deactivate when activation is released
        let views = self.viewInfos.compactMap(\.view)
        let constraints = self.constraints
        Task {
            await Self.deactiveConstraints(constraints)
            await Self.deactiveViews(views)
        }
    }

    @MainActor
    static func deactiveConstraints(_ constraints: Set<WeakConstraint>) {
        let constraints = constraints.compactMap(\.origin).filter(\.isActive)
        NSLayoutConstraint.deactivate(constraints)
    }

    @MainActor
    static func deactiveViews(_ views: [UIView]) {
        for view in views {
            if views.contains(where: { $0 == view.superview }) {
                view.removeFromSuperview()
            }
        }
    }
}

extension Activation {
    @MainActor
    public func deactive() {
        let views = self.viewInfos.compactMap(\.view)
        let constraints = self.constraints

        Self.deactiveViews(views)
        Self.deactiveConstraints(constraints)
    }

    @MainActor
    public func viewForIdentifier(_ identifier: String) -> UIView? {
        viewInfos.first(where: { $0.identifier == identifier })?.view
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
        hasher.combine(viewInfos)
        hasher.combine(constraints)
    }
}
