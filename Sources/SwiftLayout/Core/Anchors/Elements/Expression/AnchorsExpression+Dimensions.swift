//
//  AnchorsExpression+Dimensions.swift
//

import UIKit

extension AnchorsExpression where Attribute == AnchorsDimensionAttribute {

    init(dimensions attributes: Attribute...) {
        self.attributes = attributes
    }

    public var height: Self { Self.init(from: self, appendedAttribute: .height) }
    public var width: Self { Self.init(from: self, appendedAttribute: .width) }

    public func equalTo(constant: CGFloat) -> Anchors {
        let constraintProperties = constraintProperties(relation: .equal, toItem: .deny, toAttribute: nil, constant: constant)
        return Anchors(constraintProperties)
    }

    public func greaterThanOrEqualTo(constant: CGFloat) -> Anchors {
        let constraintProperties = constraintProperties(relation: .greaterThanOrEqual, toItem: .deny, toAttribute: nil, constant: constant)
        return Anchors(constraintProperties)
    }

    public func lessThanOrEqualTo(constant: CGFloat) -> Anchors {
        let constraintProperties = constraintProperties(relation: .lessThanOrEqual, toItem: .deny, toAttribute: nil, constant: constant)
        return Anchors(constraintProperties)
    }

    public func equalTo(_ layoutAnchor: NSLayoutDimension, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = UIView().widthAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        let constraintProperties = constraintProperties(relation: .equal, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
        return Anchors(constraintProperties)
    }

    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutDimension, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = UIView().widthAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        let constraintProperties = constraintProperties(relation: .greaterThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
        return Anchors(constraintProperties)
    }

    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutDimension, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = UIView().widthAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        let constraintProperties = constraintProperties(relation: .lessThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
        return Anchors(constraintProperties)
    }
}

extension AnchorsExpression where Attribute == AnchorsDimensionAttribute {
    public var centerX: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.centerX) }
    public var leading: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.leading) }
    public var trailing: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.trailing) }
    public var left: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.left) }
    public var right: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.right) }
    public var centerXWithinMargins: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.centerXWithinMargins) }
    public var leftMargin: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.leftMargin) }
    public var rightMargin: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.rightMargin) }
    public var leadingMargin: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.leadingMargin) }
    public var trailingMargin: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.trailingMargin) }

    public var centerY: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.centerY) }
    public var top: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.top) }
    public var bottom: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.bottom) }
    public var firstBaseline: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.firstBaseline) }
    public var lastBaseline: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.lastBaseline) }
    public var centerYWithinMargins: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.centerYWithinMargins) }
    public var topMargin: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.topMargin) }
    public var bottomMargin: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsYAxisAttribute.bottomMargin) }
}
