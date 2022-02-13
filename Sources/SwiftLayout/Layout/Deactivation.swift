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
        let constraints = constraints.compactMap(\.o)
        NSLayoutConstraint.deactivate(constraints)
        let views = views.compactMap(\.o)
        for view in views {
            view.removeConstraints(constraints)
            if views.contains(where: { $0 == view.superview }) {
                view.removeFromSuperview()
            }
        }
    }
    
    func updateLayout(_ layout: Layout) {
        let layout = layout.prepare()
        guard self.views != layout.viewReferences || self.constraints != layout.constraintReferences else { return }
        deactive()
        self.views = layout.viewReferences
        layout.attachSuperview(nil)
        self.constraints = layout.constraintReferences
        layout.activeConstraints()
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
