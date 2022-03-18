//
//  LayoutElements.swift
//  
//
//  Created by aiden_h on 2022/03/09.
//
import UIKit

class LayoutElements {
    let viewInformations: [ViewInformation]
    let viewConstraints: [NSLayoutConstraint]
    
    init(layout: Layout) {
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

private enum LayoutExplorer {
    struct Component {
        var superView: UIView? = nil
        var view: UIView
        var anchors: Anchors? = nil
    }
    
    typealias TraversalHandler = (_ layout: Layout, _ superview: UIView?) -> Void
    
    static func components(layout: Layout) -> [Component] {
        var elements: [Component] = []
        
        traversal(layout: layout, superview: nil) { layout, superview in
            if let view = layout.view {
                elements.append(Component(superView: superview, view: view, anchors: layout.anchors))
            }
        }
        
        return elements
    }
    
    static func traversal(layout: Layout, superview: UIView?, handler: TraversalHandler) {
        handler(layout, superview)
        
        let nextSuperview = layout.view ?? superview
        layout.sublayouts.forEach { layout in
            traversal(layout: layout, superview: nextSuperview, handler: handler)
        }
    }
}
