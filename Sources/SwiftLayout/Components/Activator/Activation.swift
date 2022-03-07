//
//  Activation.swift
//  
//
//  Created by aiden_h on 2022/02/16.
//

import UIKit

public final class Activation: Hashable {
    
    typealias Constraints = Set<WeakReference<NSLayoutConstraint>>
    
    var viewInfos: ViewInformationSet
    var constraints: Constraints
    
    convenience init() {
        self.init(viewInfos: .init(), constraints: .init())
    }
    
    init(viewInfos: ViewInformationSet, constraints: Constraints) {
        self.viewInfos = viewInfos
        self.constraints = constraints
    }
    
    deinit {
        deactive()
    }
    
    func deactiveConstraints() {
        let constraints = constraints.compactMap(\.origin).filter(\.isActive)
        NSLayoutConstraint.deactivate(constraints)
        self.constraints = .init()
    }
    
    func deactiveViews() {
        let views = viewInfos.infos.compactMap(\.view)
        for view in views {
            if views.contains(where: { $0 == view.superview }) {
                view.removeFromSuperview()
            }
        }
        self.viewInfos = .init()
    }
}

extension Activation {
    public func deactive() {
        deactiveViews()
        deactiveConstraints()
    }
    
    public func viewForIdentifier(_ identifier: String) -> UIView? {
        viewInfos.infos.first(where: { $0.identifier == identifier })?.view
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
