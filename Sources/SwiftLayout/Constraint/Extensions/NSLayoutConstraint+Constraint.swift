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
    
    private var firstConstraintElement: SwiftLayout.ConstraintElement {
        SwiftLayout.ConstraintElement(item: SwiftLayout.ConstraintElementItem(self.firstItem), attribute: firstAttribute)
    }
    
    private var secondConstraintElement: SwiftLayout.ConstraintElement? {
        return SwiftLayout.ConstraintElement(item: .none, attribute: secondAttribute)
    }
    
    private var constraintRule: SwiftLayout.ConstraintRule {
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
        default:
            return ""
        }
    }
}
