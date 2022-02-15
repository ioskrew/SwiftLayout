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
        self.constraints = constraints
        self.identifier = identifier
        
        sublayouts.forEach { impl in
            impl.superlayout = self
        }
    }
    
    let view: UIView
    
    private(set) var superlayout: LayoutImpl?
    private(set) var sublayouts: [LayoutImpl] = []
    private(set) var constraints: [Constraint] = []
    
    var identifier: String?
    
    var animationDisabled: Bool = false
    
    public var debugDescription: String {
        if sublayouts.isEmpty {
            return view.tagDescription
        } else {
            return view.tagDescription + ": [\(sublayouts.map(\.debugDescription).joined(separator: ", "))]"
        }
    }
    
    func appendSublayouts(_ sublayouts: [LayoutImpl]) {
        sublayouts.forEach { impl in
            impl.superlayout = self
        }
        self.sublayouts.append(contentsOf: sublayouts)
    }
    
    func appendConstraints(_ constraints: [Constraint]) {
        self.constraints.append(contentsOf: constraints)
    }
    
    var viewInformations: [ViewInformation] {
        return [ViewInformation(superview: superlayout?.view, view: view, identifier: identifier, animationDisabled: animationDisabled)]
        + sublayouts.flatMap(\.viewInformations)
    }
    
    func viewConstraints(_ identifiers: ViewIdentifiers? = nil) -> [NSLayoutConstraint] {
        return self.constraints.flatMap({ constraint in
            constraint.constraints(item: view, toItem: superlayout?.view, identifiers: identifiers)
        }) + sublayouts.flatMap({ impl in
            impl.viewConstraints(identifiers)
        })
    }
}

