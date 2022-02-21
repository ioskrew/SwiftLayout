//
//  Anchor.swift
//  
//
//  Created by maylee on 2022/02/08.
//

import Foundation
import UIKit

public final class Anchors: Constraint {
    
    public convenience init(_ attributes: NSLayoutConstraint.Attribute...) {
        let items = attributes.map { Anchors.Constraint(attribute: $0) }
        self.init(items: items)
    }
    
    public convenience init(_ attributes: [NSLayoutConstraint.Attribute]) {
        let items = attributes.map { Anchors.Constraint(attribute: $0) }
        self.init(items: items)
    }
    
    internal init(items: [Anchors.Constraint] = []) {
        self.items = items
    }
    
    var items: [Constraint] = []
    
    public func setConstant(_ constant: CGFloat) -> Self {
        for i in 0..<items.count {
            items[i].constant = constant
        }
        return self
    }
    
    private func to(_ relation: NSLayoutConstraint.Relation, to: ConstraintTarget) -> Self {
        func update(_ updateItem: Constraint) -> Constraint {
            var updateItem = updateItem
            updateItem.relation = relation
            updateItem.toItem = to.item
            updateItem.toAttribute = to.attribute
            updateItem.constant = to.constant
            return updateItem
        }
        
        items = items.map(update)
        return self
    }
    
    public func equalTo(constant: CGFloat) -> Self {
        to(.equal, to: .init(item: .deny, attribute: nil, constant: constant))
    }
    
    public func greaterThanOrEqualTo(constant: CGFloat = .zero) -> Self {
        to(.greaterThanOrEqual, to: .init(item: .deny, attribute: nil, constant: constant))
    }
    
    public func lessThanOrEqualTo(constant: CGFloat = .zero) -> Self {
        to(.lessThanOrEqual, to: .init(item: .deny, attribute: nil, constant: constant))
    }
    
    public func equalTo<I>(_ toItem: I) -> Self where I: ConstraintableItem {
        to(.equal, to: .init(item: toItem, attribute: nil, constant: .zero))
    }
    
    public func greaterThanOrEqualTo<I>(_ toItem: I) -> Self where I: ConstraintableItem {
        to(.greaterThanOrEqual, to: .init(item: toItem, attribute: nil, constant: .zero))
    }
    
    public func lessThanOrEqualTo<I>(_ toItem: I) -> Self where I: ConstraintableItem {
        to(.lessThanOrEqual, to: .init(item: toItem, attribute: nil, constant: .zero))
    }
    
    public func equalTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute) -> Self where I: ConstraintableItem {
        to(.equal, to: .init(item: toItem, attribute: attribute, constant: .zero))
    }
    
    public func greaterThanOrEqualTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute) -> Self where I: ConstraintableItem {
        to(.greaterThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: .zero))
    }
    
    public func lessThanOrEqualTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute) -> Self where I: ConstraintableItem {
        to(.lessThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: .zero))
    }
    
    public func equalTo<I>(_ toItem: I, constant: CGFloat) -> Self where I: ConstraintableItem {
        to(.equal, to: .init(item: toItem, attribute: nil, constant: constant))
    }
    
    public func greaterThanOrEqualTo<I>(_ toItem: I, constant: CGFloat) -> Self where I: ConstraintableItem {
        to(.greaterThanOrEqual, to: .init(item: toItem, attribute: nil, constant: constant))
    }
    
    public func lessThanOrEqualTo<I>(_ toItem: I, constant: CGFloat) -> Self where I: ConstraintableItem {
        to(.lessThanOrEqual, to: .init(item: toItem, attribute: nil, constant: constant))
    }
    
    public func equalTo<I>(_ toItem: I?, attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Self where I: ConstraintableItem {
        to(.equal, to: .init(item: toItem, attribute: attribute, constant: constant))
    }
    
    public func greaterThanOrEqualTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Self where I: ConstraintableItem {
        to(.greaterThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: constant))
    }
    
    public func lessThanOrEqualTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Self where I: ConstraintableItem {
        to(.lessThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: constant))
    }
    
    public func constraints(item fromItem: NSObject, toItem: NSObject?) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for item in items {
            let from = fromItem
            let attribute = item.attribute
            let relation = item.relation
            let to = item.toItem(toItem)
            let toAttribute = item.toAttribute(attribute)
            let multiplier = item.multiplier
            let constant = item.constant
            assert(to is UIView || to is UILayoutGuide || to == nil, "to: \(to.debugDescription) is not item")
            constraints.append(NSLayoutConstraint(item: from,
                                                  attribute: attribute,
                                                  relatedBy: relation,
                                                  toItem: to,
                                                  attribute: toAttribute,
                                                  multiplier: multiplier,
                                                  constant: constant))
        }
        return constraints
    }
    
    public func constraints(item fromItem: NSObject, toItem: NSObject?, identifiers: ViewInformationSet?) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for item in items {
            let from = fromItem
            let attribute = item.attribute
            let relation = item.relation
            let to = item.toItem(toItem, identifiers: identifiers)
            let toAttribute = item.toAttribute(attribute)
            let multiplier = item.multiplier
            let constant = item.constant
            assert(to is UIView || to is UILayoutGuide || to == nil, "to: \(to.debugDescription) is not item")
            constraints.append(NSLayoutConstraint(item: from,
                                                  attribute: attribute,
                                                  relatedBy: relation,
                                                  toItem: to,
                                                  attribute: toAttribute,
                                                  multiplier: multiplier,
                                                  constant: constant))
        }
        return constraints
    }
    
    struct ConstraintTarget {
        public init<I>(item: I?, attribute: NSLayoutConstraint.Attribute?, constant: CGFloat) where I: ConstraintableItem {
            self.item = ItemFromView(item).item
            self.attribute = attribute
            self.constant = constant
        }
        
        init(item: Item = .transparent, attribute: NSLayoutConstraint.Attribute?, constant: CGFloat) {
            self.item = item
            self.attribute = attribute
            self.constant = constant
        }
        
        let item: Item
        let attribute: NSLayoutConstraint.Attribute?
        let constant: CGFloat
    }
    
    struct Constraint: Hashable {
        var attribute: NSLayoutConstraint.Attribute
        var relation: NSLayoutConstraint.Relation = .equal
        var toItem: Item = .transparent
        var toAttribute: NSLayoutConstraint.Attribute?
        
        var constant: CGFloat = 0.0
        var multiplier: CGFloat = 1.0
        
        func toItem(_ toItem: NSObject?, identifiers: ViewInformationSet? = nil) -> NSObject? {
            switch self.toItem {
            case let .object(object):
                return object
            case let .identifier(identifier):
                return identifiers?[identifier] ?? toItem
            case .transparent:
                return toItem
            case .deny:
                switch attribute {
                case .width, .height:
                    return nil
                default:
                    return toItem
                }
            }
        }
        
        func toAttribute(_ attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint.Attribute {
            return toAttribute ?? attribute
        }
    }
    
    enum Item: Hashable {
        case object(NSObject)
        case identifier(String)
        case transparent
        case deny
        
        init(_ item: Any?) {
            if let string = item as? String {
                self = .identifier(string)
            } else if let object = item as? NSObject {
                self = .object(object)
            } else {
                self = .transparent
            }
        }
        
        var object: NSObject? {
            switch self {
            case let .object(object):
                return object
            default:
                return nil
            }
        }
    }
}
