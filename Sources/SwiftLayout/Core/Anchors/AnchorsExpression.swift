//
//  AnchorsExpression.swift
//  
//
//  Created by aiden_h on 2022/03/27.
//

import UIKit
import SwiftUI

public struct AnchorsExpression<Attribute: AnchorsAttribute> {
    var attributes: [Attribute]
    var relation: NSLayoutConstraint.Relation = .equal
    var toItem: Item = .transparent
    var toAttribute: Attribute? = nil
    
    var constant: CGFloat = 0.0
    var multiplier: CGFloat = 1.0
    
    init(
        from anchors: AnchorsExpression<Attribute>,
        relation: NSLayoutConstraint.Relation,
        toItem: Item,
        toAttribute: Attribute? = nil,
        constant: CGFloat = 0.0,
        multiplier: CGFloat = 1.0
    ) {
        self.attributes = anchors.attributes
        self.relation = relation
        self.toItem = toItem
        self.toAttribute = toAttribute
        self.constant = constant
        self.multiplier = multiplier
    }
    
    init(from anchors: AnchorsExpression<Attribute>, appendedAttribute: Attribute) {
        self.attributes = anchors.attributes + [appendedAttribute]
        self.relation = anchors.relation
        self.toItem = anchors.toItem
        self.toAttribute = anchors.toAttribute
        self.constant = anchors.constant
        self.multiplier = anchors.multiplier
    }
    
    var constraints: [Constraint] {
        attributes.map {
            Constraint(
                attribute: $0.attribute,
                relation: relation,
                toItem: toItem,
                toAttribute: toAttribute?.attribute,
                constant: constant,
                multiplier: multiplier
            )
        }
    }
    
    func targetFromConstraint(_ constraint: NSLayoutConstraint) -> (toItem: Item, toAttribute: Attribute?) {
        if let object = constraint.secondItem as? NSObject {
            return (toItem: .object(object), toAttribute: Attribute(attribute: constraint.secondAttribute))
        } else {
            return (toItem: self.toItem, toAttribute: Attribute(attribute: constraint.secondAttribute))
        }
    }
}

extension AnchorsExpression {
    
    public func equalToSuper(attribute: Attribute? = nil, constant: CGFloat = .zero) -> Self {
        Self.init(from: self, relation: .equal, toItem: .transparent, toAttribute: attribute, constant: constant)
    }
    
    public func greaterThanOrEqualToSuper(attribute: Attribute? = nil, constant: CGFloat = .zero) -> Self {
        Self.init(from: self, relation: .greaterThanOrEqual, toItem: .transparent, toAttribute: attribute, constant: constant)
    }
    
    public func lessThanOrEqualToSuper(attribute: Attribute? = nil, constant: CGFloat = .zero) -> Self {
        Self.init(from: self, relation: .lessThanOrEqual, toItem: .transparent, toAttribute: attribute, constant: constant)
    }

    public func equalTo<I>(_ toItem: I, attribute: Attribute? = nil, constant: CGFloat = .zero) -> Self where I: ConstraintableItem {
        Self.init(from: self, relation: .equal, toItem: ItemFromView(toItem).item, toAttribute: attribute, constant: constant)
    }
    
    public func greaterThanOrEqualTo<I>(_ toItem: I, attribute: Attribute? = nil, constant: CGFloat = .zero) -> Self where I: ConstraintableItem {
        Self.init(from: self, relation: .greaterThanOrEqual, toItem: ItemFromView(toItem).item, toAttribute: attribute, constant: constant)
    }
    
    public func lessThanOrEqualTo<I>(_ toItem: I, attribute: Attribute? = nil, constant: CGFloat = .zero) -> Self where I: ConstraintableItem {
        Self.init(from: self, relation: .lessThanOrEqual, toItem: ItemFromView(toItem).item, toAttribute: attribute, constant: constant)
    }
    
    public func constant(_ constant: CGFloat) -> Self {
        Self.init(from: self, relation: self.relation, toItem: self.toItem, constant: constant)
    }
    
    public func multiplier(_ multiplier: CGFloat) -> Self {
        Self.init(from: self, relation: self.relation, toItem: self.toItem, multiplier: multiplier)
    }
}

extension AnchorsExpression where Attribute == AnchorsXAxisAttribute {
    
    init(xAxis attributes: Attribute...) {
        self.attributes = attributes
    }
    
    public var centerX: Self { Self.init(from: self, appendedAttribute: .centerX) }
    public var leading: Self { Self.init(from: self, appendedAttribute: .leading) }
    public var trailing: Self { Self.init(from: self, appendedAttribute: .trailing) }
    public var left: Self { Self.init(from: self, appendedAttribute: .left) }
    public var right: Self { Self.init(from: self, appendedAttribute: .right) }
    public var centerXWithinMargins: Self { Self.init(from: self, appendedAttribute: .centerXWithinMargins) }
    public var leftMargin: Self { Self.init(from: self, appendedAttribute: .leftMargin) }
    public var rightMargin: Self { Self.init(from: self, appendedAttribute: .rightMargin) }
    public var leadingMargin: Self { Self.init(from: self, appendedAttribute: .leadingMargin) }
    public var trailingMargin: Self { Self.init(from: self, appendedAttribute: .trailingMargin) }

    public func equalTo(_ layoutAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().leadingAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .equal, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().leadingAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .greaterThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().leadingAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .lessThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
}

extension AnchorsExpression where Attribute == AnchorsYAxisAttribute {
    
    init(yAxis attributes: Attribute...) {
        self.attributes = attributes
    }

    public var centerY: Self { Self.init(from: self, appendedAttribute: .centerY) }
    public var top: Self { Self.init(from: self, appendedAttribute: .top) }
    public var bottom: Self { Self.init(from: self, appendedAttribute: .bottom) }
    public var firstBaseline: Self { Self.init(from: self, appendedAttribute: .firstBaseline) }
    public var lastBaseline: Self { Self.init(from: self, appendedAttribute: .lastBaseline) }
    public var centerYWithinMargins: Self { Self.init(from: self, appendedAttribute: .centerYWithinMargins) }
    public var topMargin: Self { Self.init(from: self, appendedAttribute: .topMargin) }
    public var bottomMargin: Self { Self.init(from: self, appendedAttribute: .bottomMargin) }
    
    public func equalTo(_ layoutAnchor: NSLayoutYAxisAnchor, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().topAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .equal, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutYAxisAnchor, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().topAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .greaterThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutYAxisAnchor, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().topAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .lessThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
}

extension AnchorsExpression where Attribute == AnchorsDimensionAttribute {
    
    init(dimensions attributes: Attribute...) {
        self.attributes = attributes
    }

    public func equalTo(constant: CGFloat) -> Self {
        Self.init(from: self, relation: .equal, toItem: .deny, constant: constant)
    }
    
    public var height: Self { Self.init(from: self, appendedAttribute: .height) }
    public var width: Self { Self.init(from: self, appendedAttribute: .width) }
    
    public func equalTo(_ layoutAnchor: NSLayoutDimension, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().widthAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .equal, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutDimension, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().widthAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .greaterThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutDimension, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().widthAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .lessThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
}
