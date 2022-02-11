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
    
    public weak var view: UIView?
    var constraint: C
    
    public var layouts: [Layout] = []
    var constraints: [NSLayoutConstraint] = []
    
    public var hashable: AnyHashable {
        AnyHashable([view.hashable, constraint.hashable, layouts.hashable])
    }
    
    public func attachSuperview(_ superview: UIView?) {
        guard let view = view else {
            return
        }
        if let superview = superview {
            superview.addSubview(view)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        for layout in layouts {
            layout.attachSuperview(view)
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
