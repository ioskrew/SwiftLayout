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
}

extension Activation {
    @MainActor
    public func deactive() {
        let views = self.viewInfos.compactMap(\.view)
        let constraints = self.constraints

        Deactivator().deactivate(views: views, constraints: constraints)
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
