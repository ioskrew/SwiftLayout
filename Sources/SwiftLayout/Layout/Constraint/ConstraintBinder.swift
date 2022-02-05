//
//  ConstraintBinder.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

public struct ConstraintBinder {
    
    var firstAttribute: NSLayoutConstraint.Attribute = .notAnAttribute
    var secondAttribute: NSLayoutConstraint.Attribute = .notAnAttribute
    var secondItem: AnyObject?
    var relation: NSLayoutConstraint.Relation = .equal
    
    var needToBeSecond: Bool = false
    
    init() {}
    
    public var top: Self {
        var binder = self
        if binder.needToBeSecond {
            binder.secondAttribute = .top
        } else {
            binder.firstAttribute = .top
        }
        return binder
    }
    
    public var to: Self {
        var binder = self
        binder.needToBeSecond = true
        return binder
    }
    
    public var equal: Self {
        var binder = self
        binder.relation = .equal
        return binder
    }
    
    public func of(_ view: UIView) -> Self {
        var binder = self
        binder.secondItem = view
        return binder
    }
    
}

extension Array: Constraint where Element == ConstraintBinder {}
