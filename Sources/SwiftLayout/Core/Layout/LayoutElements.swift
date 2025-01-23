//
//  LayoutElements.swift
//  
//
//  Created by aiden_h on 2022/03/09.
//

import UIKit

@MainActor
struct LayoutElements<L: Layout> {
    let viewInformations: [ViewInformation]
    let viewConstraints: [NSLayoutConstraint]

    init(layout: L) {
        let components = layout.layoutComponents(superview: nil, option: .none)

        viewInformations = components.map { component in
            ViewInformation(superview: component.superview, view: component.view, option: component.option)
        }

        let viewDic = Dictionary(
            components.compactMap { $0.keyValueTuple },
            uniquingKeysWith: { first, _ in first }
        )

        viewConstraints = components.flatMap { component in
            component.anchors.constraints(
                item: component.view,
                toItem: component.superview,
                viewDic: viewDic
            )
        }
    }
}
