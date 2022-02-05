//
//  ConstraintLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

public final class ConstraintLayout<C>: LayoutViewContainable where C: Constraint {
   
    internal init(view: UIView, constraint: C) {
        self.view = view
        self.constraint = constraint
    }
    
    public let view: UIView
    let constraint: C
    
    public var layouts: [Layout] = []
    var constraints: [NSLayoutConstraint] = []
    
    public func attachSuperview(_ superview: UIView?) {
        superview?.addSubview(self.view)
        self.constraints = constraint.constraints(item: view, toItem: superview)
        for constraint in constraints {
            constraint.isActive = true
        }
    }
    
}
