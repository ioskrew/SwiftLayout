//
//  AnchorsCenterExpression.swift
//
//
//  Created by aiden_h on 2023/04/19.
//

import SwiftLayoutPlatform

@MainActor
public struct AnchorsCenterExpression: AnchorsExpressionOmitable {
    init() {}

    public func defaultExpression() -> Anchors {
        equalToSuper()
    }

    func constraintProperties(
        relation: NSLayoutConstraint.Relation = .equal,
        toItem: AnchorsItem = .transparent,
        xConstant: CGFloat = 0.0,
        yConstant: CGFloat = 0.0
    ) -> [AnchorsConstraintProperty] {
        [
            AnchorsConstraintProperty(
                attribute: .centerX,
                relation: relation,
                toItem: toItem,
                toAttribute: .centerX,
                constant: xConstant
            ),
            AnchorsConstraintProperty(
                attribute: .centerY,
                relation: relation,
                toItem: toItem,
                toAttribute: .centerY,
                constant: yConstant
            )
        ]
    }

    public func equalToSuper(xOffset: CGFloat = .zero, yOffset: CGFloat = .zero) -> Anchors {
        let constraintProperties = constraintProperties(relation: .equal, toItem: .transparent, xConstant: xOffset, yConstant: yOffset)
        return Anchors(constraintProperties)
    }

    public func equalTo<I>(_ toItem: I, xOffset: CGFloat = .zero, yOffset: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        let constraintProperties = constraintProperties(relation: .equal, toItem: AnchorsItem(toItem), xConstant: xOffset, yConstant: yOffset)
        return Anchors(constraintProperties)
    }
}
