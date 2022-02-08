//
//  Anchor.swift
//  
//
//  Created by maylee on 2022/02/08.
//

import Foundation
import UIKit

public struct Anchors: Constraint {
    
    public init(_ attributes: NSLayoutConstraint.Attribute...) {
        let items = attributes.map { Anchors.Item(attribute: $0) }
        self.init(items: items)
    }
    
    public init(_ attributes: [NSLayoutConstraint.Attribute]) {
        let items = attributes.map { Anchors.Item(attribute: $0) }
        self.init(items: items)
    }
    
    internal init(items: [Anchors.Item] = []) {
        self.items = items
    }
    
    var items: [Item] = []
    
    public var hashable: AnyHashable {
        AnyHashable(items)
    }
    
    private func to(_ relation: NSLayoutConstraint.Relation, to: To) -> Self {
        var a = self
        
        func update(_ updateItem: Item) -> Item {
            var updateItem = updateItem
            updateItem.relation = relation
            updateItem.toItem = to.item
            updateItem.toAttribute = to.attribute
            updateItem.constant = to.constant
            updateItem.toNeeds = to.toNeeds
            return updateItem
        }
        
        a.items = a.items.map(update)
        return a
    }
    
    public func equalTo(_ toItem: NSObject? = nil, attribute: NSLayoutConstraint.Attribute? = nil) -> Self {
        to(.equal, to: .init(item: toItem, attribute: attribute, constant: .zero))
    }
    
    public func greaterThanOrEqualTo(_ toItem: NSObject? = nil, attribute: NSLayoutConstraint.Attribute? = nil) -> Self {
        to(.greaterThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: .zero))
    }
    
    public func lessThanOrEqualTo(_ toItem: NSObject? = nil, attribute: NSLayoutConstraint.Attribute? = nil) -> Self {
        to(.lessThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: .zero))
    }
    public func equalTo(_ toItem: NSObject? = nil, attribute: NSLayoutConstraint.Attribute? = nil, constant: CGFloat) -> Self {
        to(.equal, to: .init(item: toItem, attribute: attribute, constant: constant))
    }
    
    public func greaterThanOrEqualTo(_ toItem: NSObject? = nil, attribute: NSLayoutConstraint.Attribute? = nil, constant: CGFloat) -> Self {
        to(.greaterThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: constant))
    }
    
    public func lessThanOrEqualTo(_ toItem: NSObject? = nil, attribute: NSLayoutConstraint.Attribute? = nil, constant: CGFloat) -> Self {
        to(.lessThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: constant))
    }
    
    public func constraints(item fromItem: NSObject, toItem: NSObject?) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for item in items {
            constraints.append(NSLayoutConstraint(item: fromItem,
                                                  attribute: item.attribute,
                                                  relatedBy: item.relation,
                                                  toItem: item.toItem(toItem),
                                                  attribute: item.toAttribute(item.attribute),
                                                  multiplier: item.multiplier,
                                                  constant: item.constant))
        }
        return constraints
    }
    
    private struct To {
        let item: NSObject?
        let attribute: NSLayoutConstraint.Attribute?
        let constant: CGFloat
        
        var toNeeds: Bool {
            item != nil || attribute != nil
        }
    }
    
    struct Item: Hashable {
        var attribute: NSLayoutConstraint.Attribute
        var relation: NSLayoutConstraint.Relation = .equal
        var toNeeds: Bool = true
        var toItem: NSObject?
        var toAttribute: NSLayoutConstraint.Attribute?
        
        var constant: CGFloat = 0.0
        var multiplier: CGFloat = 1.0
        
        func toItem(_ toItem: NSObject?) -> NSObject? {
            guard toNeeds else { return nil }
            return self.toItem ?? toItem
        }
        
        func toAttribute(_ attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint.Attribute {
            guard toNeeds else { return .notAnAttribute }
            return toAttribute ?? attribute
        }
    }
    
}
