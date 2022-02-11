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
        self.strongView = view
        self.constraint = constraint
    }
    
    public var view: UIView? {
        if let view = strongView {
            return view
        } else if let view = weakView {
            return view
        } else {
            return nil
        }
    }
    private weak var weakView: UIView?
    private var strongView: UIView?
    
    var constraint: C
    
    public var layouts: [Layout] = []
    var constraints: [NSLayoutConstraint] = []
    
    public var hashable: AnyHashable {
        AnyHashable([view.hashable, constraint.hashable, layouts.hashable])
    }
    
    public func attachSuperview(_ superview: UIView?) {
        guard let view = self.view else { return }
        superview?.addSubview(view)
        if let strongView = strongView {
            weakView = strongView
            self.strongView = nil
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
