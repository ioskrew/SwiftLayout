//
//  AnyDeactivatable.swift
//  
//
//  Created by aiden_h on 2022/02/10.
//

import Foundation
import UIKit

final class Deactivation: Deactivable {
    
    private var views: [WeakReference<UIView>] = []
    private var constraints: [WeakReference<NSLayoutConstraint>] = []
    
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
        layout.prepareSuperview(nil)
        layout.attachSuperview()
        layout.prepareConstraints()
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
