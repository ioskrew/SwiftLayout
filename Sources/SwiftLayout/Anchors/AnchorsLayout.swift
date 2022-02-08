//
//  AnchorsLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

public final class AnchorsLayout<C>: ViewContainableLayout where C: Constraint {
   
    internal init(view: UIView, constraint: C) {
        self.view = view
        self.constraint = constraint
    }
    
    public let view: UIView
    var constraint: C
    
    public var layouts: [Layout] = []
    var constraints: [NSLayoutConstraint] = []
    
    public func attachSuperview(_ superview: UIView?) {
        superview?.addSubview(self.view)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        for layout in layouts {
            layout.attachSuperview(self.view)
        }
        self.constraints = constraint.constraints(item: view, toItem: superview)
    }
    
    public func activeConstraints() {
        NSLayoutConstraint.activate(self.constraints)
        for layout in layouts {
            layout.activeConstraints()
        }
    }
    
    public func deactiveConstraints() {
        for layout in layouts {
            layout.deactiveConstraints()
        }
        NSLayoutConstraint.deactivate(self.constraints)
    }
    
    public func subviews<L>(@LayoutBuilder _ build: () -> L) -> Self where L: Layout {
        layouts.append(build())
        return self
    }
    
}
