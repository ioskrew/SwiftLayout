//
//  NSLayoutConstraint+Description.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import UIKit

extension NSLayoutConstraint {
    
    var firstShort: String? {
        if let view = self.firstItem as? UIView {
            return view.tagDescription
        } else if let guide = self.firstItem as? UILayoutGuide {
            return guide.propertyDescription
        } else {
            return nil
        }
    }
    
    var secondShort: String? {
        if let view = self.secondItem as? UIView {
            return view.tagDescription
        } else if let guide = self.secondItem as? UILayoutGuide {
            return guide.propertyDescription
        } else {
            return nil
        }
    }
    
    var constantShort: String? {
        if constant < 0 {
            return "- \(abs(constant).description)"
        } else if constant > 0 {
            return "+ \(constant.description)"
        } else {
            return nil
        }
    }
    
    var multiplierShort: String? {
        if multiplier != 1.0 {
            return "x \(multiplier.description)"
        } else {
            return nil
        }
    }
    
    public var shortDescription: String {
        var shorts: [String] = []
        if let firstShort = firstShort {
            shorts.append("\(firstShort).\(firstAttribute.description)")
        }
        shorts.append(relation.shortDescription)
        if let secondShort = secondShort {
            shorts.append("\(secondShort).\(secondAttribute.description)")
        }
        if let constantShort = constantShort {
            shorts.append(constantShort)
        }
        if let multiplierShort = multiplierShort {
            shorts.append(multiplierShort)
        }
        return shorts.joined(separator: " ")
    }
}

extension NSLayoutConstraint.Attribute: CustomStringConvertible {
    public var description: String {
        if let description = attributeDescriptions[self] {
            return description
        } else {
            return "unknown"
        }
    }
}

extension NSLayoutConstraint.Attribute: CustomDebugStringConvertible {
    public var debugDescription: String {
        "NSLayoutConstraint.Attribute.\(self.description)"
    }
}

extension NSLayoutConstraint.Relation: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .lessThanOrEqual:
            return "lessThanOrEqual"
        case .equal:
            return "equal"
        case .greaterThanOrEqual:
            return "greaterThanOrEqual"
        @unknown default:
            return "???"
        }
    }
    public var debugDescription: String {
        switch self {
        case .lessThanOrEqual:
            return "NSLayoutConstraint.Relation.lessThanOrEqual"
        case .equal:
            return "NSLayoutConstraint.Relation.equal"
        case .greaterThanOrEqual:
            return "NSLayoutConstraint.Relation.greaterThanOrEqual"
        @unknown default:
            return "NSLayoutConstraint.Relation.unknown"
        }
    }
    var shortDescription: String {
        switch self {
        case .equal:
            return "=="
        case .greaterThanOrEqual:
            return ">="
        case .lessThanOrEqual:
            return "<="
        @unknown default:
            return "?"
        }
    }
}

extension Array where Element: NSLayoutConstraint {
    public var shortDescription: String {
        map(\.shortDescription).joined(separator: "\n")
    }
}

private let attributeDescriptions: [NSLayoutConstraint.Attribute: String] = [
    .left: "left",
    .right: "right",
    .top: "top",
    .bottom: "bottom",
    .leading: "leading",
    .trailing: "trailing",
    .width: "width",
    .height: "height",
    .centerX: "centerX",
    .centerY: "centerY",
    .lastBaseline: "lastBaseline",
    .firstBaseline: "firstBaseline",
    .leftMargin: "leftMargin",
    .rightMargin: "rightMargin",
    .topMargin: "topMargin",
    .bottomMargin: "bottomMargin",
    .leadingMargin: "leadingMargin",
    .trailingMargin: "trailingMargin",
    .centerXWithinMargins: "centerXWithinMargins",
    .centerYWithinMargins: "centerYWithinMargins",
    .notAnAttribute: "notAnAttribute",
]
