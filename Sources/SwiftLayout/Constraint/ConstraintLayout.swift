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
        self.constraints = constraint.constraints(item: view, toItem: superview)
        for constraint in constraints {
            constraint.isActive = true
        }
    }
    
}

extension ConstraintLayout: ConstraintCreating {}
