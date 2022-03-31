//
//  LayoutExplorer.swift
//  
//
//  Created by aiden_h on 2022/03/19.
//

import UIKit

enum LayoutExplorer {
    struct Component {
        var superView: UIView? 
        var view: UIView
        var anchors: AnchorsContainer
        
        var keyValueTuple: (String, UIView)? {
            guard let identifier = view.accessibilityIdentifier else {
                return nil
            }
            
            return (identifier, view)
        }
    }
    
    typealias TraversalHandler = (_ layout: Layout, _ superview: UIView?) -> Void
    
    static func components<L: Layout>(layout: L) -> [Component] {
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
