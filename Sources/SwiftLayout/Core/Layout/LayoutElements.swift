//
//  LayoutElements.swift
//  
//
//  Created by aiden_h on 2022/03/09.
//

import UIKit

@MainActor
struct LayoutElements<L: Layout> {
    let hierarchyInfos: [HierarchyInfo]
    let viewConstraints: [NSLayoutConstraint]

    init(layout: L) {
        let components = layout.layoutComponents(superview: nil, option: .none)

        hierarchyInfos = components.map { component in
            HierarchyInfo(superview: component.superview, node: component.node, option: component.option)
        }

        let viewDic = Dictionary(
            components.compactMap { $0.keyValueTuple },
            uniquingKeysWith: { first, _ in first }
        )

        viewConstraints = components.flatMap { component in
            component.anchors.constraints(
                item: component.node,
                toItem: component.superview,
                viewDic: viewDic
            )
        }
    }
}
