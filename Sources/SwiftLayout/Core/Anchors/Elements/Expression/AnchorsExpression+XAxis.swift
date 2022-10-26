//
//  AnchorsExpression+XAxis.swift
//  

import UIKit

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
        let constraintProperties = constraintProperties(relation: .equal, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
        return Anchors(constraintProperties)
    }

    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = UIView().leadingAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        let constraintProperties = constraintProperties(relation: .greaterThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
        return Anchors(constraintProperties)
    }

    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = UIView().leadingAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        let constraintProperties = constraintProperties(relation: .lessThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
        return Anchors(constraintProperties)
    }

    public func equalTo(_ layoutAnchor: NSLayoutXAxisAnchor, inwardOffset: CGFloat) -> Anchors {
        let tmpConstraint = UIView().leadingAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        let constraintProperties = constraintProperties(relation: .equal, toItem: target.toItem, toAttribute: target.toAttribute, inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }

    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutXAxisAnchor, inwardOffset: CGFloat) -> Anchors {
        let tmpConstraint = UIView().leadingAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        let constraintProperties = constraintProperties(relation: .greaterThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }

    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutXAxisAnchor, inwardOffset: CGFloat) -> Anchors {
        let tmpConstraint = UIView().leadingAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        let constraintProperties = constraintProperties(relation: .lessThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }
}

extension AnchorsExpression where Attribute == AnchorsXAxisAttribute {
    public var centerY: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.centerY) }
    public var top: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.top) }
    public var bottom: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.bottom) }
    public var firstBaseline: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.firstBaseline) }
    public var lastBaseline: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.lastBaseline) }
    public var centerYWithinMargins: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.centerYWithinMargins) }
    public var topMargin: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.topMargin) }
    public var bottomMargin: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.bottomMargin) }

    public var height: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsDimensionAttribute.height) }
    public var width: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsDimensionAttribute.width) }
}
