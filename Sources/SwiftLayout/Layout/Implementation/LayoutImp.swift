//
//  LayoutImp.swift
//  
//
//  Created by aiden_h on 2022/02/15.
//

import UIKit

struct LayoutImp: Layout {
    
    let view: UIView
    
    let sublayouts: [LayoutImp]
    let anchors: [Constraint]
    
    var animationDisabled: Bool = false
    var identifier: String? {
        get { view.accessibilityIdentifier }
        set { view.accessibilityIdentifier = newValue }
    }
    
    init?(layout: Layout, sublayouts: [Layout]? = nil, anchors: [Constraint]? = nil) {
        let sublayoutImp = sublayouts?.compactMap { LayoutImp(layout: $0) }
        
        if let view = layout as? UIView? {
            guard let view = view else { return nil }
            self.view = view
            self.sublayouts = sublayoutImp ?? []
            self.anchors = anchors ?? []
        } else if let layoutImp = layout as? LayoutImp {
            self.view = layoutImp.view
            self.sublayouts = sublayoutImp ?? layoutImp.sublayouts
            self.anchors = anchors ?? layoutImp.anchors
        } else if let layoutImps = layout as? [LayoutImp], !layoutImps.isEmpty {
            var layoutImps = layoutImps
            let firstLayout = layoutImps.removeFirst()
            self.view = firstLayout.view
            self.sublayouts = (sublayoutImp ?? firstLayout.sublayouts) + layoutImps
            self.anchors = anchors ?? firstLayout.anchors
        } else {
            assertionFailure("received layout is not acceptable type: \(type(of: layout))")
            return nil
        }
    }
    
    var debugDescription: String {
        if sublayouts.isEmpty {
            return view.tagDescription
        } else {
            return view.tagDescription + ": [\(sublayouts.map(\.debugDescription).joined(separator: ", "))]"
        }
    }
}

extension LayoutImp {
    func traversal(superLayout: LayoutImp? = nil, handler: (_ superLayout: LayoutImp?, _ currentLayout: LayoutImp) -> Void) {
        handler(superLayout, self)
        sublayouts.forEach { $0.traversal(superLayout: self, handler: handler) }
    }
    
    var viewInformations: [ViewInformation] {
        var result: [ViewInformation] = []
        
        traversal { superLayout, currentLayout in
            result.append(
                ViewInformation(
                    superview: superLayout?.view,
                    view: currentLayout.view,
                    identifier: currentLayout.identifier,
                    animationDisabled: currentLayout.animationDisabled
                )
            )
        }
        
        return result
    }
    
    func viewConstraints(_ identifiers: ViewInformationSet? = nil) -> [NSLayoutConstraint] {
        var result: [NSLayoutConstraint] = []
        
        traversal { superLayout, currentLayout in
            result.append(contentsOf: currentLayout.anchors.flatMap {
                $0.constraints(item: currentLayout.view, toItem: superLayout?.view, identifiers: identifiers)
            })
        }
        
        return result
    }
}
