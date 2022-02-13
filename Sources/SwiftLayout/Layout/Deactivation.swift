//
//  AnyDeactivatable.swift
//  
//
//  Created by aiden_h on 2022/02/10.
//

import Foundation
import UIKit

final class Deactivation: Deactivable {
    
    private var views: Set<WeakReference<UIView>> = []
    private var constraints: Set<WeakReference<NSLayoutConstraint>> = []
    
    init(_ layout: Layout) {
        updateLayout(layout)
    }
    
    deinit {
        deactive()
    }
    
    func deactive() {
        deactiveViews()
        deactiveConstraints()
    }
    
    func deactiveConstraints() {
        let constraints = constraints.compactMap(\.o).filter(\.isActive)
        NSLayoutConstraint.deactivate(constraints)
        self.constraints = []
    }
    
    func deactiveViews() {
        let views = views.compactMap(\.o)
        for view in views {
            if views.contains(where: { $0 == view.superview }) {
                view.removeFromSuperview()
            }
        }
    }
    
    func updateLayout(_ layout: Layout) {
        let layout = layout.prepare()
        let sameView = ReferenceCompare(left: views, right: layout.viewReferences).isSame
        let sameConstraint = ReferenceCompare(left: constraints, right: layout.constraintReferences).isSame
        switch (sameView, sameConstraint) {
        case (false, _):
            deactiveViews()
            deactiveConstraints()
            layout.attachSuperview(nil)
            layout.activeConstraints()
            views = layout.viewReferences
            constraints = layout.constraintReferences
        case (true, false):
            deactiveConstraints()
            layout.activeConstraints()
            constraints = layout.constraintReferences
        case (true, true):
            break
        }
    }
    
}

extension Layout {
    var viewReferences: Set<WeakReference<UIView>> {
        Set(layoutViews.map(WeakReference.init))
    }
    var constraintReferences: Set<WeakReference<NSLayoutConstraint>> {
        Set(layoutConstraints.map(WeakReference.init))
    }
}

struct ReferenceCompare<R, C> where R: Hashable, C: Collection, C.Element == WeakReference<R>, C: Equatable {
    let left: C
    let right: C
    
    var isSame: Bool {
        left == right
    }
}
