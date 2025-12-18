//
//  AnchorsExpression+YAxis.swift
//

import SwiftLayoutPlatform

extension AnchorsExpression where Attribute == AnchorsYAxisAttribute {

    init(yAxis attributes: Attribute...) {
        self.attributes = attributes
    }

    public var centerY: Self { Self(from: self, appendedAttribute: .centerY) }
    public var top: Self { Self(from: self, appendedAttribute: .top) }
    public var bottom: Self { Self(from: self, appendedAttribute: .bottom) }
    public var firstBaseline: Self { Self(from: self, appendedAttribute: .firstBaseline) }
    public var lastBaseline: Self { Self(from: self, appendedAttribute: .lastBaseline) }
    #if canImport(UIKit)
    public var centerYWithinMargins: Self { Self(from: self, appendedAttribute: .centerYWithinMargins) }
    public var topMargin: Self { Self(from: self, appendedAttribute: .topMargin) }
    public var bottomMargin: Self { Self(from: self, appendedAttribute: .bottomMargin) }
    #endif

    public func equalTo(_ layoutAnchor: NSLayoutYAxisAnchor, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = SLView().topAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        let constraintProperties = constraintProperties(relation: .equal, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
        return Anchors(constraintProperties)
    }

    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutYAxisAnchor, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = SLView().topAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        let constraintProperties = constraintProperties(relation: .greaterThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
        return Anchors(constraintProperties)
    }

    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutYAxisAnchor, constant: CGFloat = .zero) -> Anchors {
        let tmpConstraint = SLView().topAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        let constraintProperties = constraintProperties(relation: .lessThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
        return Anchors(constraintProperties)
    }

    public func equalTo(_ layoutAnchor: NSLayoutYAxisAnchor, inwardOffset: CGFloat) -> Anchors {
        let tmpConstraint = SLView().topAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        let constraintProperties = constraintProperties(relation: .equal, toItem: target.toItem, toAttribute: target.toAttribute, inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }

    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutYAxisAnchor, inwardOffset: CGFloat) -> Anchors {
        let tmpConstraint = SLView().topAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        let constraintProperties = constraintProperties(relation: .greaterThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }

    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutYAxisAnchor, inwardOffset: CGFloat) -> Anchors {
        let tmpConstraint = SLView().topAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        let constraintProperties = constraintProperties(relation: .lessThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }
}

extension AnchorsExpression where Attribute == AnchorsYAxisAttribute {
    public var centerX: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.centerX) }
    public var leading: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.leading) }
    public var trailing: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.trailing) }
    public var left: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.left) }
    public var right: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.right) }
    #if canImport(UIKit)
    public var centerXWithinMargins: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.centerXWithinMargins) }
    public var leftMargin: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.leftMargin) }
    public var rightMargin: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.rightMargin) }
    public var leadingMargin: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.leadingMargin) }
    public var trailingMargin: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsXAxisAttribute.trailingMargin) }
    #endif

    public var height: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsDimensionAttribute.height) }
    public var width: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsDimensionAttribute.width) }
}
