//
//  AnyDeactivatable.swift
//  
//
//  Created by aiden_h on 2022/02/10.
//

import Foundation
import UIKit

final class Deactivation: Deactivable {
    
    private var viewPairs: Set<ViewPair> = []
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
        let views = viewPairs.compactMap(\.view)
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
        let newViewPairs = Set(layoutViews)
        for viewPair in viewPairs where !newViewPairs.contains(viewPair) {
            viewPair.removeFromSuperview()
        }
        for viewPair in layoutViews {
            viewPair.addSuperview()
        }
        let layoutConstraints = layout.layoutConstraints
        let newConstraints = layout.constraintReferences
        viewPairs = newViewPairs
        NSLayoutConstraint.activate(layoutConstraints)
        constraints = newConstraints
        
        if animated, let root = viewPairs.first(where: { $0.superview == nil })?.view {
            UIView.animate(withDuration: 0.25) {
                root.layoutIfNeeded()
                layout.animation()
            }
        }
    }
    
}

extension Layout {
    var constraintReferences: Set<WeakReference<NSLayoutConstraint>> {
        Set(layoutConstraints.map(WeakReference.init))
    }
}
