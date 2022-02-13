//
//  AnchorsLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

public final class AnchorsLayout<C>: ViewContainable, Layout where C: Constraint {
   
    internal init(view: UIView, constraint: C) {
        self.view = view
        self.constraint = constraint
    }
    
    public weak var superview: UIView?
    public let view: UIView
    
    var constraint: C
    
    public var sublayouts: [Layout] = []
    var constraints: [NSLayoutConstraint] = []
    
    public func prepareSuperview(_ superview: UIView?) {
        self.superview = superview
        for layout in sublayouts {
            layout.prepareSuperview(view)
        }
    }
    
    public func prepareConstraints() {
        self.constraints = constraint.constraints(item: view, toItem: superview)
        for layout in sublayouts {
            layout.prepareConstraints()
        }
    }
    
    public func activeConstraints() {
        NSLayoutConstraint.activate(self.constraints)
        for layout in sublayouts {
            layout.activeConstraints()
        }
    }
    
    public func subviews(@LayoutBuilder _ build: () -> [Layout]) -> Self {
        sublayouts.append(contentsOf: build())
        return self
    }
    
}

extension AnchorsLayout: LayoutFlattening {
    var layoutConstraints: [NSLayoutConstraint] {
        constraints
    }
}
