//
//  Deactivator.swift
//  
//
//  Created by aiden_h on 8/8/24.
//

import UIKit

@MainActor
struct Deactivator {
    func deactivate(hierarchyInfo: [HierarchyInfo], constraints: Set<WeakConstraint>) {
        deactiveConstraints(constraints)
        deactiveHierarchy(hierarchyInfo)
    }

    private func deactiveConstraints(_ constraints: Set<WeakConstraint>) {
        let constraints = constraints.compactMap(\.origin).filter(\.isActive)
        NSLayoutConstraint.deactivate(constraints)
    }

    private func deactiveHierarchy(_ hierarchyInfos: [HierarchyInfo]) {
        for hierarchyInfos in hierarchyInfos {
            hierarchyInfos.removeFromSuperview()
        }
    }
}
