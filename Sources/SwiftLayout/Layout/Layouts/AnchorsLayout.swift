//
//  AnchorsLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

public final class AnchorsLayout<C> where C: Constraint {
    
    internal init(superview: UIView? = nil, view: UIView, constraint: C, sublayouts: [Layout] = [], constraints: [NSLayoutConstraint] = [], identifier: String? = nil, animationDisabled: Bool = false) {
        self.superview = superview
        self.view = view
        self.constraint = constraint
        self.sublayouts = sublayouts
        self.constraints = constraints
        self.identifier = identifier
        self.animationDisabled = animationDisabled
    }
    
    public weak var superview: UIView?
    public let view: UIView
    
    var constraint: C
    
    public var sublayouts: [Layout] = []
    var constraints: [NSLayoutConstraint] = []
    
    var identifier: String? = nil
    
    public func subviews(@LayoutBuilder _ build: () -> [Layout]) -> Self {
        sublayouts.append(contentsOf: build())
        return self
    }
   
    public func updateSuperview(_ superview: UIView?) {
        self.superview = superview
    }
    
    private(set) public var animationDisabled: Bool = false
    public func animationDisable() -> Self {
        animationDisabled = true
        return self
    }
}

extension AnchorsLayout: Layout, ViewContainable {
    
    public var layoutConstraints: [NSLayoutConstraint] {
        constraints + sublayouts.layoutConstraints
    }
    
    public func prepareConstraints() {
        self.constraints = constraint.constraints(item: view, toItem: superview)
        sublayouts.prepareConstraints()
    }
    
}
