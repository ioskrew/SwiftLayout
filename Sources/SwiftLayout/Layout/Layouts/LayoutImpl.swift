//
//  ViewLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public final class LayoutImpl: Layout {
    
    internal init(view: UIView,
                  superlayout: LayoutImpl? = nil,
                  sublayouts: [LayoutImpl] = [],
                  constraints: [Constraint] = [],
                  identifier: String? = nil) {
        self.view = view
        self.superlayout = superlayout
        self.sublayouts = sublayouts
        self.identifier = identifier
    }
    
    let view: UIView
    
    var superlayout: LayoutImpl?
    var sublayouts: [LayoutImpl] = []
    var constraints: [Constraint] = []
    
    var identifier: String?
    
    var animationDisabled: Bool = false
    
    public var debugDescription: String {
        if sublayouts.isEmpty {
            return view.tagDescription
        } else {
            return view.tagDescription + ": [\(sublayouts.map(\.debugDescription).joined(separator: ", "))]"
        }
    }
    
    var viewInformations: [ViewInformation] {
        return [ViewInformation(superview: superlayout?.view, view: view, identifier: identifier, animationDisabled: animationDisabled)]
        + sublayouts.map { sublayout in
            return ViewInformation(superview: view, view: sublayout.view, identifier: sublayout.identifier, animationDisabled: sublayout.animationDisabled)
        }
    }
    
    func viewConstraints(_ identifiers: ViewIdentifiers) -> [NSLayoutConstraint] {
        return self.constraints.flatMap({ constraint in
            constraint.constraints(item: view, toItem: superlayout?.view, identifiers: identifiers)
        }) + sublayouts.flatMap({ impl in
            impl.viewConstraints(identifiers)
        })
    }
}

