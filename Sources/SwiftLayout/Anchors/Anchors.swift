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
    
    public func to(_ relation: NSLayoutConstraint.Relation, to: To) -> Self {
        func update(_ updateItem: Constraint) -> Constraint {
            var updateItem = updateItem
            updateItem.relation = relation
            updateItem.toItem = to.item
            updateItem.toAttribute = to.attribute
            updateItem.constant = to.constant
            updateItem.toNeeds = to.toNeeds
            return updateItem
        }
        
        items = items.map(update)
        return self
    }
    
    public func equalTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute? = nil) -> Self where I: ConstraintItem {
        to(.equal, to: .init(item: toItem, attribute: attribute, constant: .zero))
    }
    
    public func greaterThanOrEqualTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute? = nil) -> Self where I: ConstraintItem {
        to(.greaterThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: .zero))
    }
    
    public func lessThanOrEqualTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute? = nil) -> Self where I: ConstraintItem {
        to(.lessThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: .zero))
    }
    
    public func equalTo<I>(_ toItem: I?, attribute: NSLayoutConstraint.Attribute? = nil, constant: CGFloat) -> Self where I: ConstraintItem {
        to(.equal, to: .init(item: toItem, attribute: attribute, constant: constant))
    }
    
    public func equalTo(constant: CGFloat) -> Self {
        to(.equal, to: .init(attribute: nil, constant: constant))
    }
    
    public func greaterThanOrEqualTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute? = nil, constant: CGFloat) -> Self where I: ConstraintItem {
        to(.greaterThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: constant))
    }
    
    public func lessThanOrEqualTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute? = nil, constant: CGFloat) -> Self where I: ConstraintItem {
        to(.lessThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: constant))
    }
    
    public func constraints(item fromItem: NSObject, toItem: NSObject?) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for item in items {
            let from = fromItem
            let to = item.toItem(toItem)
            assert(to is UIView || to is UILayoutGuide || to == nil, "to: \(to.debugDescription) is not item")
            constraints.append(NSLayoutConstraint(item: from,
                                                  attribute: item.attribute,
                                                  relatedBy: item.relation,
                                                  toItem: to,
                                                  attribute: item.toAttribute(item.attribute),
                                                  multiplier: item.multiplier,
                                                  constant: item.constant))
        }
        return constraints
    }
    
    public func constraints(item fromItem: NSObject, toItem: NSObject?, identifiers: ViewIdentifiers) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for item in items {
            let from = fromItem
            let to = item.toItem(toItem)
            assert(to is UIView || to is UILayoutGuide || to == nil, "to: \(to.debugDescription) is not item")
            constraints.append(NSLayoutConstraint(item: from,
                                                  attribute: item.attribute,
                                                  relatedBy: item.relation,
                                                  toItem: to,
                                                  attribute: item.toAttribute(item.attribute),
                                                  multiplier: item.multiplier,
                                                  constant: item.constant))
        }
        return constraints
    }
    
    public struct To {
        public init<I>(item: I, attribute: NSLayoutConstraint.Attribute?, constant: CGFloat) where I: ConstraintItem {
            self.item = item.item
            self.attribute = attribute
            self.constant = constant
        }
        
        public init(attribute: NSLayoutConstraint.Attribute?, constant: CGFloat) {
            self.item = .none
            self.attribute = attribute
            self.constant = constant
        }
        
        let item: Item
        let attribute: NSLayoutConstraint.Attribute?
        let constant: CGFloat
        
        var toNeeds: Bool {
            item != .none || attribute != nil
        }
    }
    
    struct Constraint: Hashable {
        var attribute: NSLayoutConstraint.Attribute
        var relation: NSLayoutConstraint.Relation = .equal
        var toNeeds: Bool = true
        var toItem: Item = .none
        var toAttribute: NSLayoutConstraint.Attribute?
        
        var constant: CGFloat = 0.0
        var multiplier: CGFloat = 1.0
        
        func toItem(_ toItem: NSObject?) -> NSObject? {
            guard toNeeds else { return .none }
            if self.toItem == .none {
                return toItem
            } else {
                return self.toItem.object
            }
        }
        
        func toAttribute(_ attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint.Attribute {
            guard toNeeds else { return .notAnAttribute }
            return toAttribute ?? attribute
        }
    }
    
    public enum Item: Hashable {
        case object(NSObject)
        case identifier(String)
        case none
        
        init(_ item: Any?) {
            if let object = item as? NSObject {
                self = .object(object)
            } else if let string = item as? String {
                self = .identifier(string)
            } else {
                self = .none
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

public protocol ConstraintItem {
    
    var item: Anchors.Item { get }
    
}

extension UIView: ConstraintItem {
    public var item: Anchors.Item {
        .init(self)
    }
}

extension UILayoutGuide: ConstraintItem {
    public var item: Anchors.Item {
        .init(self)
    }
}

extension String: ConstraintItem {
    public var item: Anchors.Item {
        .init(self)
    }
}

extension Optional: ConstraintItem where Wrapped: ConstraintItem {
    public var item: Anchors.Item {
        switch self {
        case let .some(item):
            return .init(item)
        case .none:
            return .none
        }
    }
}
