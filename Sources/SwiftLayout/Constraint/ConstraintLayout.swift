//
//  ConstraintLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

public final class ConstraintLayout: LayoutViewContainable {
   
    internal init(view: UIView, constraint: [ConstraintBinding]) {
        self.view = view
        self.constraint = constraint
    }
    
    public let view: UIView
    var constraint: [ConstraintBinding]
    
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
    
    public func layout<L>(@LayoutBuilder _ build: () -> L) -> Self where L: Layout {
        layouts.append(build())
        return self
    }
    
}

extension ConstraintLayout: ConstraintCreating {}
