//
//  AnchorsExpression.swift
//

import UIKit

public struct AnchorsExpression<Attribute: AnchorsAttribute>: AnchorsExpressionOmitable {
    var attributes: [Attribute]

    init(from anchors: AnchorsExpression<Attribute>, appendedAttribute: Attribute) {
        self = anchors
        self.attributes += [appendedAttribute]
    }

    public func defaultExpression() -> Anchors {
        equalToSuper()
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

    func constraintProperties(
        relation: NSLayoutConstraint.Relation,
        toItem: AnchorsItem,
        toAttribute: Attribute?,
        inwardOffset: CGFloat
    ) ->  [AnchorsConstraintProperty] {
        attributes.map {
            AnchorsConstraintProperty(
                attribute: $0.attribute,
                relation: relation,
                toItem: toItem,
                toAttribute: toAttribute?.attribute,
                constant: inwardOffset * $0.inwardDirectionFactor
            )
        }
    }

    func targetFromConstraint(_ constraint: NSLayoutConstraint) -> (toItem: AnchorsItem, toAttribute: Attribute?) {
        if let object = constraint.secondItem as? NSObject {
            return (toItem: .object(object), toAttribute: Attribute(attribute: constraint.secondAttribute))
        } else {
            return (toItem: .transparent, toAttribute: Attribute(attribute: constraint.secondAttribute))
        }
    }
}

extension AnchorsExpression {
    public func equalToSuper(attribute: Attribute? = nil, constant: CGFloat = .zero) -> Anchors {
        let constraintProperties = constraintProperties(relation: .equal, toItem: .transparent, toAttribute: attribute, constant: constant)
        return Anchors(constraintProperties)
    }

    public func greaterThanOrEqualToSuper(attribute: Attribute? = nil, constant: CGFloat = .zero) -> Anchors {
        let constraintProperties = constraintProperties(relation: .greaterThanOrEqual, toItem: .transparent, toAttribute: attribute, constant: constant)
        return Anchors(constraintProperties)
    }

    public func lessThanOrEqualToSuper(attribute: Attribute? = nil, constant: CGFloat = .zero) -> Anchors {
        let constraintProperties = constraintProperties(relation: .lessThanOrEqual, toItem: .transparent, toAttribute: attribute, constant: constant)
        return Anchors(constraintProperties)
    }

    public func equalTo<I>(_ toItem: I, attribute: Attribute? = nil, constant: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        let constraintProperties = constraintProperties(relation: .equal, toItem: AnchorsItem(toItem), toAttribute: attribute, constant: constant)
        return Anchors(constraintProperties)
    }

    public func greaterThanOrEqualTo<I>(_ toItem: I, attribute: Attribute? = nil, constant: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        let constraintProperties = constraintProperties(relation: .greaterThanOrEqual, toItem: AnchorsItem(toItem), toAttribute: attribute, constant: constant)
        return Anchors(constraintProperties)
    }

    public func lessThanOrEqualTo<I>(_ toItem: I, attribute: Attribute? = nil, constant: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        let constraintProperties = constraintProperties(relation: .lessThanOrEqual, toItem: AnchorsItem(toItem), toAttribute: attribute, constant: constant)
        return Anchors(constraintProperties)
    }
}

extension AnchorsExpression {
    public func equalToSuper(attribute: Attribute? = nil, inwardOffset: CGFloat) -> Anchors {
        let constraintProperties = constraintProperties(relation: .equal, toItem: .transparent, toAttribute: attribute, inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }

    public func greaterThanOrEqualToSuper(attribute: Attribute? = nil, inwardOffset: CGFloat) -> Anchors {
        let constraintProperties = constraintProperties(relation: .greaterThanOrEqual, toItem: .transparent, toAttribute: attribute, inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }

    public func lessThanOrEqualToSuper(attribute: Attribute? = nil, inwardOffset: CGFloat) -> Anchors {
        let constraintProperties = constraintProperties(relation: .lessThanOrEqual, toItem: .transparent, toAttribute: attribute, inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }

    public func equalTo<I>(_ toItem: I, attribute: Attribute? = nil, inwardOffset: CGFloat) -> Anchors where I: AnchorsItemable {
        let constraintProperties = constraintProperties(relation: .equal, toItem: AnchorsItem(toItem), toAttribute: attribute, inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }

    public func greaterThanOrEqualTo<I>(_ toItem: I, attribute: Attribute? = nil, inwardOffset: CGFloat) -> Anchors where I: AnchorsItemable {
        let constraintProperties = constraintProperties(relation: .greaterThanOrEqual, toItem: AnchorsItem(toItem), toAttribute: attribute, inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }

    public func lessThanOrEqualTo<I>(_ toItem: I, attribute: Attribute? = nil, inwardOffset: CGFloat) -> Anchors where I: AnchorsItemable {
        let constraintProperties = constraintProperties(relation: .lessThanOrEqual, toItem: AnchorsItem(toItem), toAttribute: attribute, inwardOffset: inwardOffset)
        return Anchors(constraintProperties)
    }
}
