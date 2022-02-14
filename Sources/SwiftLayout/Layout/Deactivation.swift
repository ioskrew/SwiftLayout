//
//  AnyDeactivatable.swift
//  
//
//  Created by aiden_h on 2022/02/10.
//

import Foundation
import UIKit

final class Deactivation: Deactivable {
    
    var views: Set<ViewInformation> = []
    var constraints: Set<WeakReference<NSLayoutConstraint>> = []
    
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
        let views = views.compactMap(\.view)
        for view in views {
            if views.contains(where: { $0 == view.superview }) {
                view.removeFromSuperview()
            }
        }
    }
    
    func updateLayout(_ layout: Layout, animated: Bool = false) {
        let layout = layout.prepare()
        deactiveConstraints()
        let layoutViews = layout.layoutViews
        let newViews = Set(layoutViews)
        for view in views where !newViews.contains(view) {
            view.removeFromSuperview()
        }
        for view in layoutViews {
            view.addSuperview()
        }
        let layoutConstraints = layout.layoutConstraints
        let newConstraints = layout.constraintReferences
        views = newViews
        NSLayoutConstraint.activate(layoutConstraints)
        constraints = newConstraints
        
        if animated, let root = views.first(where: { $0.superview == nil })?.view {
            UIView.animate(withDuration: 0.25) {
                root.layoutIfNeeded()
                layout.animation()
            }
        }
    }
    
    func viewForIdentifier(_ identifier: String) -> UIView? {
        views.first(where: { $0.identifier == identifier })?.view
    }
}

extension Layout {
    var constraintReferences: Set<WeakReference<NSLayoutConstraint>> {
        Set(layoutConstraints.map(WeakReference.init))
    }
}
