//
//  LayoutExplorer.swift
//  
//
//  Created by aiden_h on 2022/03/19.
//

import UIKit

enum LayoutExplorer {
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

extension LayoutExplorer {
    static func debugLayoutStructure(layout: Layout, indent: String = "", sublayoutIndent: String = "") -> [String] {
        var result = ["\(indent)\(layout.description)"]
        let sublayouts = layout.sublayouts.filter { type(of: $0) != EmptyLayout.self }
        
        sublayouts.enumerated().forEach { i, sublayout in
            if i == sublayouts.count - 1 {
                result += debugLayoutStructure(layout: sublayout, indent: sublayoutIndent + "└─ ", sublayoutIndent: sublayoutIndent + "   ")
            } else {
                result += debugLayoutStructure(layout: sublayout, indent: sublayoutIndent + "├─ ", sublayoutIndent: sublayoutIndent + "│  ")
            }
        }
        
        return result
    }
}
