//
//  AnchorsSizeExpression.swift
//
//
//  Created by aiden_h on 2023/04/19.
//

import SwiftLayoutPlatform

/// An expression type for defining width and height constraints together.
///
/// Access through ``Anchors/size``:
///
/// ```swift
/// view.sl.anchors {
///     // Fixed size
///     Anchors.size.equalTo(width: 100, height: 50)
///     Anchors.size.equalTo(CGSize(width: 100, height: 50))
///
///     // Match superview size
///     Anchors.size.equalToSuper()
///
///     // Match another view with offset
///     Anchors.size.equalTo(otherView, widthOffset: -20, heightOffset: -20)
/// }
/// ```
@MainActor
public struct AnchorsSizeExpression: AnchorsExpressionOmitable {
    init() {}

    public func defaultExpression() -> Anchors {
        equalToSuper()
    }

    func constraintProperties(
        relation: NSLayoutConstraint.Relation = .equal,
        toItem: AnchorsItem = .transparent,
        widthConstant: CGFloat = 0.0,
        heightConstant: CGFloat = 0.0
    ) -> [AnchorsConstraintProperty] {
        [
            AnchorsConstraintProperty(
                attribute: .width,
                relation: relation,
                toItem: toItem,
                toAttribute: toItem == .deny ? nil : .width,
                constant: widthConstant
            ),
            AnchorsConstraintProperty(
                attribute: .height,
                relation: relation,
                toItem: toItem,
                toAttribute: toItem == .deny ? nil : .height,
                constant: heightConstant
            )
        ]
    }

    public func equalTo(_ size: CGSize) -> Anchors {
        let constraintProperties = constraintProperties(relation: .equal, toItem: .deny, widthConstant: size.width, heightConstant: size.height)
        return Anchors(constraintProperties)
    }

    public func equalTo(width: CGFloat, height: CGFloat) -> Anchors {
        let constraintProperties = constraintProperties(relation: .equal, toItem: .deny, widthConstant: width, heightConstant: height)
        return Anchors(constraintProperties)
    }

    public func equalToSuper(widthOffset: CGFloat = .zero, heightOffset: CGFloat = .zero) -> Anchors {
        let constraintProperties = constraintProperties(relation: .equal, toItem: .transparent, widthConstant: widthOffset, heightConstant: heightOffset)
        return Anchors(constraintProperties)
    }

    public func equalTo<I>(_ toItem: I, widthOffset: CGFloat = .zero, heightOffset: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        let constraintProperties = constraintProperties(relation: .equal, toItem: AnchorsItem(toItem), widthConstant: widthOffset, heightConstant: heightOffset)
        return Anchors(constraintProperties)
    }
}
