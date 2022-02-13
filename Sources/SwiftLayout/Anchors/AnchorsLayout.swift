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
    
    private weak var superview: UIView?
    public let view: UIView
    
    var constraint: C
    
    public var layouts: [Layout] = []
    var constraints: [NSLayoutConstraint] = []
   
    public func subviews<L>(@LayoutBuilder _ build: () -> L) -> Self where L: Layout {
        layouts.append(build())
        return self
    }
    
}

extension AnchorsLayout: _Layout {
    
    public func prepareSuperview(_ superview: UIView?) {
        self.superview = superview
        for layout in _layouts {
            layout.prepareSuperview(view)
        }
    }
    
    public func attachSuperview() {
        view.translatesAutoresizingMaskIntoConstraints = false
        superview?.addSubview(view)
        for layout in _layouts {
            if let view = layout as? UIView {
                view.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(view)
            } else if let views = layout as? [UIView] {
                for view in views {
                    view.translatesAutoresizingMaskIntoConstraints = false
                    self.view.addSubview(view)
                }
            } else {
                layout.attachSuperview()
            }
        }
    }
    
    public func prepareConstraints() {
        self.constraints = constraint.constraints(item: view, toItem: superview)
        for layout in _layouts {
            layout.prepareConstraints()
        }
    }
    
    public func activeConstraints() {
        NSLayoutConstraint.activate(self.constraints)
        for layout in _layouts {
            layout.activeConstraints()
        }
    }
    
    
}

extension AnchorsLayout: LayoutFlattening {
    var layoutConstraints: [NSLayoutConstraint] {
        constraints
    }
}
