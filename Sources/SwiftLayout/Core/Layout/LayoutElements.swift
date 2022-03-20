//
//  LayoutElements.swift
//  
//
//  Created by aiden_h on 2022/03/09.
//

import UIKit

final class LayoutElements<L: Layout> {
    let viewInformations: [ViewInformation]
    let viewConstraints: [NSLayoutConstraint]
    
    init(layout: L) {
        let components = LayoutExplorer.components(layout: layout)
        
        viewInformations = components.map { component in
            ViewInformation(superview: component.superView, view: component.view)
        }
        
        let viewInfoSet = ViewInformationSet(infos: viewInformations)
        viewConstraints = components.flatMap { component in
            component.anchors?.constraints(
                item: component.view,
                toItem: component.superView,
                viewInfoSet: viewInfoSet
            ) ?? []
        }
    }
}

