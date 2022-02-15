//
//  AnyDeactivatable.swift
//  
//
//  Created by aiden_h on 2022/02/10.
//

import Foundation
import UIKit

final class Deactivation: Deactivable {
    
    let uuid = UUID()
    
    var views: Set<ViewInformation> = []
    var constraints: Set<WeakReference<NSLayoutConstraint>> = []
    
    init(_ layout: Layout) {
        guard let impl = layout as? LayoutImpl else { return }
        updateLayout(impl)
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
    
    func updateLayout(_ layout: LayoutImpl, animated: Bool = false) {
        deactiveConstraints()
        let layoutViews = layout.viewInformations
        let newViews = Set(layoutViews)
        for view in views where !newViews.contains(view) {
            view.removeFromSuperview()
        }
        for view in layoutViews {
            view.addSuperview()
        }
        let layoutConstraints = layout.viewConstraints(ViewIdentifiers(views: newViews))
        let newConstraints = layoutConstraints.weakens
        views = newViews
        NSLayoutConstraint.activate(layoutConstraints)
        constraints = Set(newConstraints)
        
        if animated, let root = views.first(where: { $0.superview == nil })?.view {
            UIView.animate(withDuration: 0.25) {
                root.layoutIfNeeded()
                layoutViews.forEach { information in
                    information.animation()
                }
            }
        }
    }
    
    func viewForIdentifier(_ identifier: String) -> UIView? {
        views.first(where: { $0.identifier == identifier })?.view
    }
}

public struct ViewIdentifiers {
    
    let views: Set<ViewInformation>
    
    subscript(_ identifier: String) -> UIView? {
        views.first(where: { $0.identifier == identifier })?.view
    }
    
}
