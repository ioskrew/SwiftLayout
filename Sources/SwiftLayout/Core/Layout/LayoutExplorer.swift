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
        
        var keyValueTupe: (String, UIView)? {
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

extension LayoutExplorer {
    static func debugLayoutStructure(layout: Layout, withAnchors: Bool = false, _ indent: String = "", _ sublayoutIndent: String = "") -> [String] {
        var result: [String] = ["\(indent)\(layout.description)"]
        
        if withAnchors {
            let anchorsIndent: String
            if layout.sublayouts.isEmpty {
                anchorsIndent = sublayoutIndent.appending("      ")
            } else {
                anchorsIndent = sublayoutIndent.appending("│     ")
            }
            let descriptions = layout.anchors.constraints.flatMap { $0.descriptions }
            if !descriptions.isEmpty {
                result.append(contentsOf: descriptions.map({ description in anchorsIndent.appending(description) }))
            }
        }
        
        var sublayouts = layout.sublayouts
        if sublayouts.isEmpty {
            return result
        } else {
            let last: Layout = sublayouts.removeLast()
            for sublayout in sublayouts {
                result.append(contentsOf: debugLayoutStructure(layout: sublayout,
                                                               withAnchors: withAnchors,
                                                               sublayoutIndent.appending("├─ "),
                                                               sublayoutIndent.appending("│  ")))
            }
            result.append(contentsOf: debugLayoutStructure(layout: last,
                                                           withAnchors: withAnchors,
                                                           sublayoutIndent.appending("└─ "),
                                                           sublayoutIndent.appending("   ")))
        }
        
        return result
    }
}
