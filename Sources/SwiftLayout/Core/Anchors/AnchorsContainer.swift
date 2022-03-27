//
//  AnchorsContainer.swift
//  
//
//  Created by aiden_h on 2022/03/27.
//

import UIKit

public final class AnchorsContainer {
    
    var constraints: [Constraint] = []
    
    init(_ constraints: [Constraint] = []) {
        self.constraints = constraints
    }
    
    init<A>(_ anchorsExpression: AnchorsExpression<A>) where A: AnchorsAttribute {
        self.constraints = anchorsExpression.constraints
    }
    
    func append(contentsOf constraints: [Constraint]) {
        self.constraints.append(contentsOf: constraints)
    }
    
    func append<A>(_ anchorsExpression: AnchorsExpression<A>) where A: AnchorsAttribute {
        self.constraints.append(contentsOf: anchorsExpression.constraints)
    }
    
    func constraints(item fromItem: NSObject, toItem: NSObject?) -> [NSLayoutConstraint] {
        constraints(item: fromItem, toItem: toItem, viewDic: [:])
    }
    
    func constraints(item fromItem: NSObject, toItem: NSObject?, viewDic: [String: UIView]) -> [NSLayoutConstraint] {
        constraints.map { item -> NSLayoutConstraint in
            let from = fromItem
            let attribute = item.attribute
            let relation = item.relation
            let to = item.toItem(toItem, viewDic: viewDic)
            let toAttribute = item.toAttribute(attribute)
            let multiplier = item.multiplier
            let constant = item.constant
            
            assert(to is UIView || to is UILayoutGuide || to == nil, "to: \(to.debugDescription) is not item")
            let constraint = NSLayoutConstraint(
                item: from,
                attribute: attribute,
                relatedBy: relation,
                toItem: to,
                attribute: toAttribute,
                multiplier: multiplier,
                constant: constant
            )
            constraint.priority = .required
            return constraint
        }
    }
}
