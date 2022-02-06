//
//  ConstraintCreating.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol ConstraintCreating {
    func constraint(_ attributes: [NSLayoutConstraint.Attribute]) -> ConstraintLayout
    func constraint(_ attributes: NSLayoutConstraint.Attribute...) -> ConstraintLayout
    func constraint(_ attributes: NSLayoutConstraint.Attribute..., relation: NSLayoutConstraint.Relation) -> ConstraintLayout
    func constraint(_ attributes: NSLayoutConstraint.Attribute..., toItem: AnyObject) -> ConstraintLayout
    func constraint(_ attributes: NSLayoutConstraint.Attribute..., relation: NSLayoutConstraint.Relation, toItem: AnyObject?) -> ConstraintLayout
    func constraint(_ attributes: [NSLayoutConstraint.Attribute], relation: NSLayoutConstraint.Relation, toItem: AnyObject?) -> ConstraintLayout
    
    func constraint(_ attribute: NSLayoutConstraint.Attribute, to itemAttribute: (AnyObject, NSLayoutConstraint.Attribute)) -> ConstraintLayout
    func constraint(_ attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, to itemAttribute: (AnyObject, NSLayoutConstraint.Attribute)) -> ConstraintLayout
}

public extension ConstraintCreating {
    
    func constraint(_ attributes: [NSLayoutConstraint.Attribute]) -> ConstraintLayout {
        self.constraint(attributes, relation: .equal, toItem: nil)
    }
    
    func constraint(_ attributes: NSLayoutConstraint.Attribute...) -> ConstraintLayout {
        self.constraint(attributes, relation: .equal, toItem: nil)
    }
    
    func constraint(_ attributes: NSLayoutConstraint.Attribute..., relation: NSLayoutConstraint.Relation) -> ConstraintLayout {
        self.constraint(attributes, relation: relation, toItem: nil)
    }
    
    func constraint(_ attributes: NSLayoutConstraint.Attribute..., toItem: AnyObject) -> ConstraintLayout {
        self.constraint(attributes, relation: .equal, toItem: toItem)
    }
    
    func constraint(_ attributes: NSLayoutConstraint.Attribute..., relation: NSLayoutConstraint.Relation, toItem: AnyObject?) -> ConstraintLayout {
        self.constraint(attributes, relation: relation, toItem: toItem)
    }
    
    func constraint(_ attribute: NSLayoutConstraint.Attribute, to itemAttribute: (AnyObject, NSLayoutConstraint.Attribute)) -> ConstraintLayout {
        self.constraint(attribute, relation: .equal, to: itemAttribute)
    }
}

public extension ConstraintCreating where Self: UIView {
    
    func constraint(_ attributes: [NSLayoutConstraint.Attribute], relation: NSLayoutConstraint.Relation, toItem: AnyObject?) -> ConstraintLayout {
        if let toItem = toItem {
            return .init(view: self, constraint: attributes.map({ attribute in
                ConstraintBinding.init(firstAttribute: attribute, firstItem: self,
                                       secondAttribute: attribute,
                                       secondItem: toItem,
                                       relation: relation)
            }))
        } else {
            return .init(view: self, constraint: attributes.map(ConstraintBinding.attribute))
        }
    }
    
    func constraint(_ attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, to itemAttribute: (AnyObject, NSLayoutConstraint.Attribute)) -> ConstraintLayout {
        .init(view: self, constraint: [
            ConstraintBinding(firstAttribute: attribute, firstItem: self,
                              secondAttribute: itemAttribute.1,
                              secondItem: itemAttribute.0,
                              relation: relation)
        ])
    }
    
}

extension ConstraintCreating where Self == ConstraintLayout {
    
    public func constraint(_ attributes: [NSLayoutConstraint.Attribute], relation: NSLayoutConstraint.Relation, toItem: AnyObject?) -> ConstraintLayout {
        if let toItem = toItem {
            self.constraint.append(contentsOf: attributes.map({ attribute in
                ConstraintBinding.init(firstAttribute: attribute, firstItem: self.view,
                                       secondAttribute: attribute,
                                       secondItem: toItem,
                                       relation: relation)
            }))
        } else {
            self.constraint.append(contentsOf: attributes.map(ConstraintBinding.attribute))
        }
        return self
    }
    
    public func constraint(_ attribute: NSLayoutConstraint.Attribute,
                           relation: NSLayoutConstraint.Relation,
                           to itemAttribute: (AnyObject, NSLayoutConstraint.Attribute)) -> ConstraintLayout {
        self.constraint.append(ConstraintBinding(firstAttribute: attribute,
                                                 secondAttribute: itemAttribute.1,
                                                 secondItem: itemAttribute.0,
                                                 relation: relation))
        return self
    }
    
}

