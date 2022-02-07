//
//  Anchor.swift
//  
//
//  Created by maylee on 2022/02/08.
//

import Foundation
import UIKit

public struct Anchor: Constraint {
    
    internal init(_ item: AnyObject? = nil, items: [Anchor.Item] = []) {
        self.item = item
        self.items = items
    }
    
    let item: AnyObject?
    
    var items: [Item] = []
    
    @Attribute(.top)            public static var top: Anchor
    @Attribute(.bottom)         public static var bottom: Anchor
    @Attribute(.leading)        public static var leading: Anchor
    @Attribute(.trailing)       public static var trailing: Anchor
    @Attribute(.left)           public static var left: Anchor
    @Attribute(.right)          public static var right: Anchor
    @Attribute(.width)          public static var width: Anchor
    @Attribute(.height)         public static var height: Anchor
    @Attribute(.centerX)        public static var centerX: Anchor
    @Attribute(.centerY)        public static var centerY: Anchor
    @Attribute(.firstBaseline)  public static var firstBaseline: Anchor
    @Attribute(.lastBaseline)   public static var lastBaseline: Anchor
    
    public var top: Anchor              { self.appendAttribute(item, .top) }
    public var bottom: Anchor           { self.appendAttribute(item, .bottom) }
    public var leading: Anchor          { self.appendAttribute(item, .leading) }
    public var trailing: Anchor         { self.appendAttribute(item, .trailing) }
    public var left: Anchor             { self.appendAttribute(item, .left) }
    public var right: Anchor            { self.appendAttribute(item, .right) }
    public var width: Anchor            { self.appendAttribute(item, .width) }
    public var height: Anchor           { self.appendAttribute(item, .height) }
    public var centerX: Anchor          { self.appendAttribute(item, .centerX) }
    public var centerY: Anchor          { self.appendAttribute(item, .centerY) }
    public var firstBaseline: Anchor    { self.appendAttribute(item, .firstBaseline) }
    public var lastBaseline: Anchor     { self.appendAttribute(item, .lastBaseline) }
    
    public func appendAttribute(_ item: AnyObject? = nil, _ attribute: NSLayoutConstraint.Attribute) -> Self {
        var a = self
        a.items.append(.init(item: item, attribute: attribute))
        return a
    }
    
    public func constant(_ constant: CGFloat) -> Self {
        var a = self
        if var last = a.items.last {
            last.constant = constant
            a.items.removeLast()
            a.items.append(last)
        }
        return a
    }
    
    public enum To {
        case item(AnyObject)
        case constant(CGFloat)
        case itemConstant(AnyObject, CGFloat)
        case itemAttribute(AnyObject, NSLayoutConstraint.Attribute)
    }
    
    public func to(_ relation: NSLayoutConstraint.Relation, to: To, all: Bool = false) -> Self {
        var a = self
        
        func update(_ updateItem: Item) -> Item {
            var updateItem = updateItem
            updateItem.relation = relation
            switch to {
            case let .item(item):
                updateItem.toItem = item
            case let .itemConstant(item, constant):
                updateItem.toItem = item
                updateItem.constant = constant
            case let .itemAttribute(item, attribute):
                updateItem.toItem = item
                updateItem.toAttribute = attribute
            case let .constant(constant):
                updateItem.constant = constant
                updateItem.toNeeds = false
            }
            return updateItem
        }
        
        if all {
            a.items = a.items.map(update)
        } else {
            if let last = a.items.last {
                let updated = update(last)
                a.items.removeLast()
                a.items.append(updated)
            }
        }
        return a
    }
    
    public func equalTo(_ toItem: AnyObject) -> Self {
        to(.equal, to: .item(toItem))
    }
    
    public func equalTo(_ toItem: AnyObject, attribute: NSLayoutConstraint.Attribute) -> Self {
        to(.equal, to: .itemAttribute(toItem, attribute))
    }
    
    public func greaterThanOrEqualTo(_ toItem: AnyObject) -> Self {
        to(.greaterThanOrEqual, to: .item(toItem))
    }
    
    public func lessThanOrEqualTo(_ toItem: AnyObject) -> Self {
        to(.lessThanOrEqual, to: .item(toItem))
    }
    
    public func equalToConstant(_ constant: CGFloat) -> Self {
        to(.equal, to: .constant(constant))
    }
    
    public func equalToAll(_ toItem: AnyObject) -> Self {
        to(.equal, to: .item(toItem), all: true)
    }
    
    public var toNone: Self {
        var a = self
        if var last = a.items.last {
            last.toNeeds = false
            a.items.removeLast()
            a.items.append(last)
        }
        return a
    }
    
    public func constraints(item fromItem: AnyObject, toItem: AnyObject?) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for item in items {
            constraints.append(NSLayoutConstraint(item: item.item ?? fromItem,
                                                  attribute: item.attribute,
                                                  relatedBy: item.relation,
                                                  toItem: item.toItem(toItem),
                                                  attribute: item.toAttribute(item.attribute),
                                                  multiplier: item.multiplier,
                                                  constant: item.constant))
        }
        return constraints
    }
    
    @propertyWrapper
    public struct Attribute {
        public var wrappedValue: Anchor
        
        public init(_ attribute: NSLayoutConstraint.Attribute) {
            wrappedValue = Anchor(items: [.init(attribute: attribute)])
        }
    }
    
    struct Item {
        var item: AnyObject?
        var attribute: NSLayoutConstraint.Attribute
        var relation: NSLayoutConstraint.Relation = .equal
        var toNeeds: Bool = true
        var toItem: AnyObject?
        var toAttribute: NSLayoutConstraint.Attribute?
        
        var constant: CGFloat = 0.0
        var multiplier: CGFloat = 1.0
        
        func toItem(_ toItem: AnyObject?) -> AnyObject? {
            guard toNeeds else { return nil }
            return self.toItem ?? toItem
        }
        
        func toAttribute(_ attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint.Attribute {
            guard toNeeds else { return .notAnAttribute }
            return toAttribute ?? attribute
        }
    }
    
}
