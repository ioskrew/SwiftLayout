//
//  Anchor.swift
//  
//
//  Created by maylee on 2022/02/08.
//

import Foundation
import UIKit

public struct Anchor: Constraint {
    
    public init(_ attributes: NSLayoutConstraint.Attribute...) {
        let items = attributes.map { Anchor.Item(attribute: $0) }
        self.init(items: items)
    }
    
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
    
    internal init(items: [Anchor.Item] = []) {
        self.items = items
    }
    
    var items: [Item] = []
    
    private struct To {
        let item: AnyObject?
        let attribute: NSLayoutConstraint.Attribute?
        let constant: CGFloat
        
        var toNeeds: Bool {
            item != nil || attribute != nil
        }
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
    
    public func equalTo(_ toItem: AnyObject? = nil, attribute: NSLayoutConstraint.Attribute? = nil, constant: CGFloat = 0) -> Self {
        to(.equal, to: .init(item: toItem, attribute: attribute, constant: constant))
    }
    
    public func greaterThanOrEqualTo(_ toItem: AnyObject? = nil, attribute: NSLayoutConstraint.Attribute? = nil, constant: CGFloat = 0) -> Self {
        to(.greaterThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: constant))
    }
    
    public func lessThanOrEqualTo(_ toItem: AnyObject? = nil, attribute: NSLayoutConstraint.Attribute? = nil, constant: CGFloat = 0) -> Self {
        to(.lessThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: constant))
    }
    
    public func constraints(item fromItem: AnyObject, toItem: AnyObject?) -> [NSLayoutConstraint] {
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
    
    @propertyWrapper
    public struct Attribute {
        public var wrappedValue: Anchor
        
        public init(_ attribute: NSLayoutConstraint.Attribute) {
            wrappedValue = Anchor(items: [.init(attribute: attribute)])
        }
    }
    
    struct Item {
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
