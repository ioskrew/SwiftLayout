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
        guard let flattening = layout.flattening() else { return }
        guard self.views != flattening.viewReferences || self.constraints != flattening.constraintReferences else { return }
        deactive()
        self.views = flattening.viewReferences
        layout.attachSuperview()
        self.constraints = flattening.constraintReferences
        layout.activeConstraints()
    }
    
}
