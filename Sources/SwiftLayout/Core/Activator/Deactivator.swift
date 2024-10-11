//
//  Deactivator.swift
//  
//
//  Created by aiden_h on 8/8/24.
//

import UIKit

@MainActor
struct Deactivator {
    func deactivate(views: [UIView], constraints: Set<WeakConstraint>) {
        deactiveConstraints(constraints)
        deactiveViews(views)
    }

    private func deactiveConstraints(_ constraints: Set<WeakConstraint>) {
        let constraints = constraints.compactMap(\.origin).filter(\.isActive)
        NSLayoutConstraint.deactivate(constraints)
    }

    private func deactiveViews(_ views: [UIView]) {
        for view in views where views.contains(where: { $0 == view.superview }) {
            view.removeFromSuperview()
        }
    }
}
