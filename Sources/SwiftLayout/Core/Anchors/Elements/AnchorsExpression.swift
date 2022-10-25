//
//  AnchorsExpression.swift
//  
//
//  Created by aiden_h on 2022/03/27.
//

import UIKit

public struct AnchorsExpression<Attribute: AnchorsAttribute> {
    private var attributes: [Attribute]

    private init(from anchors: AnchorsExpression<Attribute>, appendedAttribute: Attribute) {
        self = anchors
        self.attributes += [appendedAttribute]
    }

    
    func constraintProperties(
        relation: NSLayoutConstraint.Relation,
        toItem: AnchorsItem,
        toAttribute: Attribute?,
        constant: CGFloat
    ) ->  [AnchorsConstraintProperty] {
        attributes.map {
            AnchorsConstraintProperty(
                attribute: $0.attribute,
                relation: relation,
                toItem: toItem,
                toAttribute: toAttribute?.attribute,
                constant: constant
            )
        }
    }
    
    private func targetFromConstraint(_ constraint: NSLayoutConstraint) -> (toItem: AnchorsItem, toAttribute: Attribute?) {
        if let object = constraint.secondItem as? NSObject {
            return (toItem: .object(object), toAttribute: Attribute(attribute: constraint.secondAttribute))
        } else {
            return (toItem: .transparent, toAttribute: Attribute(attribute: constraint.secondAttribute))
        }
    }
}

extension AnchorsExpression {
    
    public func equalToSuper(attribute: Attribute? = nil, constant: CGFloat = .zero) -> Anchors {
        Anchors(from: self, relation: .equal, toItem: .transparent, toAttribute: attribute, constant: constant)
    }
    
    public func greaterThanOrEqualToSuper(attribute: Attribute? = nil, constant: CGFloat = .zero) -> Anchors {
        Anchors(from: self, relation: .greaterThanOrEqual, toItem: .transparent, toAttribute: attribute, constant: constant)
    }
    
    public func lessThanOrEqualToSuper(attribute: Attribute? = nil, constant: CGFloat = .zero) -> Anchors {
        Anchors(from: self, relation: .lessThanOrEqual, toItem: .transparent, toAttribute: attribute, constant: constant)
    }

    public func equalTo<I>(_ toItem: I, attribute: Attribute? = nil, constant: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        Anchors(from: self, relation: .equal, toItem: AnchorsItem(toItem), toAttribute: attribute, constant: constant)
    }
    
    public func greaterThanOrEqualTo<I>(_ toItem: I, attribute: Attribute? = nil, constant: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        Anchors(from: self, relation: .greaterThanOrEqual, toItem: AnchorsItem(toItem), toAttribute: attribute, constant: constant)
    }
    
    public func lessThanOrEqualTo<I>(_ toItem: I, attribute: Attribute? = nil, constant: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        Anchors(from: self, relation: .lessThanOrEqual, toItem: AnchorsItem(toItem), toAttribute: attribute, constant: constant)
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

    public func equalTo(_ layoutAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = UIView().leadingAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Anchors(from: self, relation: .equal, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = UIView().leadingAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Anchors(from: self, relation: .greaterThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = UIView().leadingAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Anchors(from: self, relation: .lessThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
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
    
    public func equalTo(_ layoutAnchor: NSLayoutYAxisAnchor, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = UIView().topAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Anchors(from: self, relation: .equal, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutYAxisAnchor, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = UIView().topAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Anchors(from: self, relation: .greaterThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutYAxisAnchor, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = UIView().topAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Anchors(from: self, relation: .lessThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
}

extension AnchorsExpression where Attribute == AnchorsDimensionAttribute {
    
    init(dimensions attributes: Attribute...) {
        self.attributes = attributes
    }
    
    public var height: Self { Self.init(from: self, appendedAttribute: .height) }
    public var width: Self { Self.init(from: self, appendedAttribute: .width) }
    
    public func equalTo(constant: CGFloat) -> Anchors {
        Anchors(from: self, relation: .equal, toItem: .deny, toAttribute: nil, constant: constant)
    }
    
    public func equalTo(_ layoutAnchor: NSLayoutDimension, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = UIView().widthAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Anchors(from: self, relation: .equal, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutDimension, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = UIView().widthAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Anchors(from: self, relation: .greaterThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutDimension, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = UIView().widthAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Anchors(from: self, relation: .lessThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
}
