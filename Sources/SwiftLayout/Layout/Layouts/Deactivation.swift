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
            view.removeFromSuperview()
        }
    }
    
    func updateLayout(_ layout: Layout) {
        guard let flattening = layout as? LayoutFlattening else { return }
        layout.prepareSuperview(nil)
        layout.prepareConstraints()
        self.views = flattening.viewReferences
        self.constraints = flattening.constraintReferences
        layout.attachSuperview()
        layout.activeConstraints()
    }
    
}

extension LayoutFlattening {
    var viewReferences: Set<WeakReference<UIView>> {
        Set(layoutViews.map(WeakReference.init))
    }
    var constraintReferences: Set<WeakReference<NSLayoutConstraint>> {
        Set(layoutConstraints.map(WeakReference.init))
    }
}
