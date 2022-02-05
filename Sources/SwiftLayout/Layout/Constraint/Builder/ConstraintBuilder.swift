//
//  ConstraintBuilder.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

@resultBuilder
public struct ConstraintBuilder {
    
    public static func buildBlock(_ components: Binding...) -> [Binding] {
        components
    }
    
    public struct Binding {
        
        internal init(firstAttribute: NSLayoutConstraint.Attribute,
                      firstItem: AnyObject? = nil,
                      secondAttribute: NSLayoutConstraint.Attribute = .notAnAttribute,
                      secondItem: AnyObject? = nil,
                      relation: NSLayoutConstraint.Relation = .equal) {
            self.firstAttribute = firstAttribute
            self.firstItem = firstItem
            self.secondAttribute = secondAttribute
            self.secondItem = secondItem
            self.relation = relation
        }
        
        var firstAttribute: NSLayoutConstraint.Attribute
        var firstItem: AnyObject?
        var secondAttribute: NSLayoutConstraint.Attribute
        var secondItem: AnyObject?
        var relation: NSLayoutConstraint.Relation = .equal
        
        func constraint(item: AnyObject, toItem: AnyObject?) -> NSLayoutConstraint {
            return NSLayoutConstraint(item: self.firstItem ?? item, attribute: firstAttribute,
                                      relatedBy: relation,
                                      toItem: secondItem ?? toItem, attribute: secondAttribute,
                                      multiplier: 1.0,
                                      constant: 0.0)
        }
    }
    
}

extension Array: Constraint where Element == ConstraintBuilder.Binding {
    public func constraints(item: AnyObject, toItem: AnyObject?) -> [NSLayoutConstraint] {
        map { binding in
            binding.constraint(item: item, toItem: toItem)
        }
    }
}
