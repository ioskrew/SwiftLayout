//
//  NSLayoutConstraint+Constraint.swift
//  
//
//  Created by oozoofrog on 2022/01/25.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    
    var binding: SwiftLayout.Binding {
        SwiftLayout.Binding(first: firstConstraintElement,
                            second: secondConstraintElement,
                            rule: constraintRule)
    }
    
    private var firstConstraintElement: SwiftLayout.Element {
        SwiftLayout.Element(item: SwiftLayout.Element.Item(self.firstItem), attribute: firstAttribute)
    }
    
    private var secondConstraintElement: SwiftLayout.Element? {
        return SwiftLayout.Element(item: .none, attribute: secondAttribute)
    }
    
    private var constraintRule: SwiftLayout.Rule {
        .init(relation: relation, multiplier: multiplier, constant: constant)
    }
    
}

extension NSLayoutConstraint.Attribute: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .leading:
            return "leading"
        case .trailing:
            return "trailing"
        case .left:
            return "left"
        case .right:
            return "right"
        case .centerX:
            return "center.x"
        case .centerY:
            return "center.y"
        case .firstBaseline:
            return "baseline.first"
        case .lastBaseline:
            return "baseline.last"
        case .width:
            return "width"
        case .height:
            return "height"
        case .notAnAttribute:
            return "none"
        default:
            return ""
        }
    }
}

extension NSLayoutConstraint.Relation: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .equal:
            return "=="
        case .greaterThanOrEqual:
            return ">="
        case .lessThanOrEqual:
            return "<="
        @unknown default:
            return ""
        }
    }
}
