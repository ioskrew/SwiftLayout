//
//  AnchorsMixedExpression.swift
//  

import UIKit

public struct AnchorsMixedExpression: AnchorsExpressionOmitable {
    private var attributes: [any AnchorsAttribute]

    init<A1, A2>(from anchors: AnchorsExpression<A1>, appendedAttribute: A2) where A1: AnchorsAttribute, A2: AnchorsAttribute {
        self.attributes = anchors.attributes + [appendedAttribute]
    }

    private init<A>(from mixedExpression: AnchorsMixedExpression, appendedAttribute: A) where A: AnchorsAttribute {
        self.attributes = mixedExpression.attributes + [appendedAttribute]
    }

    public func defaultExpression() -> Anchors {
        equalToSuper()
    }

    func constraintProperties(
        relation: NSLayoutConstraint.Relation,
        toItem: AnchorsItem,
        constant: CGFloat
    ) ->  [AnchorsConstraintProperty] {
        attributes.map {
            AnchorsConstraintProperty(
                attribute: $0.attribute,
                relation: relation,
                toItem: toItem,
                toAttribute: nil,
                constant: constant
            )
        }
    }

    private func constraintProperties(
        relation: NSLayoutConstraint.Relation,
        toItem: AnchorsItem,
        inwardOffset: CGFloat
    ) ->  [AnchorsConstraintProperty] {
        attributes.map {
            AnchorsConstraintProperty(
                attribute: $0.attribute,
                relation: relation,
                toItem: toItem,
                toAttribute: nil,
                constant: inwardOffset * $0.inwardDirectionFactor
            )
        }
    }
}

extension AnchorsMixedExpression {
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

    public var height: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsDimensionAttribute.height) }
    public var width: AnchorsMixedExpression { AnchorsMixedExpression(from: self, appendedAttribute: AnchorsDimensionAttribute.width) }
}

extension AnchorsMixedExpression {
    public func equalToSuper(constant: CGFloat = .zero) -> Anchors {
        let constraintProperties = constraintProperties(relation: .equal, toItem: .transparent, constant: constant)
        return Anchors(constraintProperties)
    }

    public func greaterThanOrEqualToSuper(constant: CGFloat = .zero) -> Anchors {
        let constraintProperties = constraintProperties(relation: .greaterThanOrEqual, toItem: .transparent, constant: constant)
        return Anchors(constraintProperties)
    }

    public func lessThanOrEqualToSuper(constant: CGFloat = .zero) -> Anchors {
        let constraintProperties = constraintProperties(relation: .lessThanOrEqual, toItem: .transparent, constant: constant)
        return Anchors(constraintProperties)
    }

    public func equalTo<I>(_ toItem: I, constant: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        let constraintProperties = constraintProperties(relation: .equal, toItem: AnchorsItem(toItem), constant: constant)
        return Anchors(constraintProperties)
    }

    public func greaterThanOrEqualTo<I>(_ toItem: I, constant: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        let constraintProperties = constraintProperties(relation: .greaterThanOrEqual, toItem: AnchorsItem(toItem), constant: constant)
        return Anchors(constraintProperties)
    }

    public func lessThanOrEqualTo<I>(_ toItem: I, constant: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        let constraintProperties = constraintProperties(relation: .lessThanOrEqual, toItem: AnchorsItem(toItem), constant: constant)
        return Anchors(constraintProperties)
    }
}

extension AnchorsMixedExpression {
    public func equalToSuper(inwardOffset: CGFloat) -> Anchors {
        let constraintProperties = constraintProperties(relation: .equal, toItem: .transparent, inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }

    public func greaterThanOrEqualToSuper(inwardOffset: CGFloat) -> Anchors {
        let constraintProperties = constraintProperties(relation: .greaterThanOrEqual, toItem: .transparent, inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }

    public func lessThanOrEqualToSuper(inwardOffset: CGFloat) -> Anchors {
        let constraintProperties = constraintProperties(relation: .lessThanOrEqual, toItem: .transparent, inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }

    public func equalTo<I>(_ toItem: I, inwardOffset: CGFloat) -> Anchors where I: AnchorsItemable {
        let constraintProperties = constraintProperties(relation: .equal, toItem: AnchorsItem(toItem), inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }

    public func greaterThanOrEqualTo<I>(_ toItem: I, inwardOffset: CGFloat) -> Anchors where I: AnchorsItemable {
        let constraintProperties = constraintProperties(relation: .greaterThanOrEqual, toItem: AnchorsItem(toItem), inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }

    public func lessThanOrEqualTo<I>(_ toItem: I, inwardOffset: CGFloat) -> Anchors where I: AnchorsItemable {
        let constraintProperties = constraintProperties(relation: .lessThanOrEqual, toItem: AnchorsItem(toItem), inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }
}
