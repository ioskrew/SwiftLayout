//
//  ConstraintBinding.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public struct ConstraintBinding {
    
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
    
    static func attribute(_ attribute: NSLayoutConstraint.Attribute) -> Self {
        ConstraintBinding(firstAttribute: attribute, secondAttribute: attribute)
    }
    
    var firstAttribute: NSLayoutConstraint.Attribute
    var firstItem: AnyObject?
    var secondAttribute: NSLayoutConstraint.Attribute
    var secondItem: AnyObject?
    var relation: NSLayoutConstraint.Relation = .equal
    
    func constraint(item: AnyObject, toItem: AnyObject?) -> NSLayoutConstraint {
        let item = self.firstItem ?? item
        let toItem = self.secondItem ?? toItem
        let constraint =  NSLayoutConstraint(item: item, attribute: firstAttribute,
                                             relatedBy: relation,
                                             toItem: toItem, attribute: secondAttribute,
                                             multiplier: 1.0,
                                             constant: 0.0)
        return constraint
    }
}
