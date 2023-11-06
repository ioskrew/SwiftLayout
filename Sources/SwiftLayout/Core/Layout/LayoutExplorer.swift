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
        var anchors: Anchors
        var option: LayoutOption
        
        var keyValueTuple: (String, UIView)? {
            guard let identifier = view.accessibilityIdentifier else {
                return nil
            }
            
            return (identifier, view)
        }
    }
    
    typealias TraversalHandler = (_ layout: any Layout, _ superview: UIView?, _ option: LayoutOption) -> Void
    
    static func components<L: Layout>(layout: L) -> [Component] {
        var elements: [Component] = []
        
        traversal(layout: layout, superview: nil, option: .none) { layout, superview, option in
            guard let view = layout.view else {
                return
            }

            elements.append(Component(superView: superview, view: view, anchors: layout.anchors, option: option))
        }
        
        return elements
    }

    static func traversal(layout: any Layout, handler: (any Layout) -> Void) {
        handler(layout)

        layout.sublayouts.forEach { layout in
            traversal(layout: layout, handler: handler)
        }
    }
    
    static func traversal(layout: any Layout, superview: UIView?, option: LayoutOption, handler: TraversalHandler) {
        handler(layout, superview, option)
        
        let nextSuperview = layout.view ?? superview
        let nextOption = layout.option ?? option
        layout.sublayouts.forEach { layout in
            traversal(layout: layout, superview: nextSuperview, option: nextOption, handler: handler)
        }
    }
}
