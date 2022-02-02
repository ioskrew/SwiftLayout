//
//  ConstraintAssistant.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

extension NSLayoutAnchor: Constraint {}

extension NSLayoutConstraint.Attribute: CustomStringConvertible {
    public var description: String {
        switch self {
        case .left:
            return "NSLayoutConstraint.Attribute.left"
        case .right:
            return "NSLayoutConstraint.Attribute.right"
        case .top:
            return "NSLayoutConstraint.Attribute.top"
        case .bottom:
            return "NSLayoutConstraint.Attribute.bottom"
        case .leading:
            return "NSLayoutConstraint.Attribute.leading"
        case .trailing:
            return "NSLayoutConstraint.Attribute.trailing"
        case .width:
            return "NSLayoutConstraint.Attribute.width"
        case .height:
            return "NSLayoutConstraint.Attribute.height"
        case .centerX:
            return "NSLayoutConstraint.Attribute.centerX"
        case .centerY:
            return "NSLayoutConstraint.Attribute.centerY"
        case .lastBaseline:
            return "NSLayoutConstraint.Attribute.lastBaseline"
        case .firstBaseline:
            return "NSLayoutConstraint.Attribute.firstBaseline"
        case .leftMargin:
            return "NSLayoutConstraint.Attribute.leftMargin"
        case .rightMargin:
            return "NSLayoutConstraint.Attribute.rightMargin"
        case .topMargin:
            return "NSLayoutConstraint.Attribute.topMargin"
        case .bottomMargin:
            return "NSLayoutConstraint.Attribute.bottomMargin"
        case .leadingMargin:
            return "NSLayoutConstraint.Attribute.leadingMargin"
        case .trailingMargin:
            return "NSLayoutConstraint.Attribute.trailingMargin"
        case .centerXWithinMargins:
            return "NSLayoutConstraint.Attribute.centerXWithinMargins"
        case .centerYWithinMargins:
            return "NSLayoutConstraint.Attribute.centerYWithinMargins"
        case .notAnAttribute:
            return "NSLayoutConstraint.Attribute.notAnAttribute"
        @unknown default:
            return "NSLayoutConstraint.Attribute.unknown"
        }
    }
}

extension NSLayoutConstraint.Relation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .lessThanOrEqual:
            return "NSLayoutConstraint.Attribute.lessThanOrEqual"
        case .equal:
            return "NSLayoutConstraint.Attribute.equal"
        case .greaterThanOrEqual:
            return "NSLayoutConstraint.Attribute.greaterThanOrEqual"
        @unknown default:
            return "NSLayoutConstraint.Attribute.unknown"
        }
    }
}
