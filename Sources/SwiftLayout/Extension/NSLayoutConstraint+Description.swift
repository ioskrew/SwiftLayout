//
//  NSLayoutConstraint+Description.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension NSLayoutConstraint {
    
    var firstShort: String? {
        if let view = self.firstItem as? SLView {
            return view.tagDescription
        } else if let guide = self.firstItem as? SLLayoutGuide, let view = guide.owningView {
            return view.tagDescription + ".safeAreaLayoutGuide"
        } else {
            return nil
        }
    }
    
    var secondShort: String? {
        if let view = self.secondItem as? SLView {
            return view.tagDescription
        } else if let guide = self.secondItem as? SLLayoutGuide, let view = guide.owningView {
            return view.tagDescription + ".safeAreaLayoutGuide"
        } else {
            return nil
        }
    }
    
    var constantShort: String? {
        if constant < 0 {
            return constant.description
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
            shorts.append(firstShort + ".\(firstAttribute.description)")
        }
        shorts.append(relation.shortDescription)
        if let secondShort = secondShort {
            shorts.append(secondShort + ".\(secondAttribute.description)")
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

extension NSLayoutConstraint.Attribute: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .left:
            return "left"
        case .right:
            return "right"
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .leading:
            return "leading"
        case .trailing:
            return "trailing"
        case .width:
            return "width"
        case .height:
            return "height"
        case .centerX:
            return "centerX"
        case .centerY:
            return "centerY"
        case .lastBaseline:
            return "lastBaseline"
        case .firstBaseline:
            return "firstBaseline"
            #if canImport(UIKit)
        case .leftMargin:
            return "leftMargin"
        case .rightMargin:
            return "rightMargin"
        case .topMargin:
            return "topMargin"
        case .bottomMargin:
            return "bottomMargin"
        case .leadingMargin:
            return "leadingMargin"
        case .trailingMargin:
            return "trailingMargin"
        case .centerXWithinMargins:
            return "centerXWithinMargins"
        case .centerYWithinMargins:
            return "centerYWithinMargins"
            #endif
        case .notAnAttribute:
            return "notAnAttribute"
        @unknown default:
            return "unknown"
        }
    }
    public var debugDescription: String {
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
            #if canImport(UIKit)
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
            #endif
        case .notAnAttribute:
            return "NSLayoutConstraint.Attribute.notAnAttribute"
        @unknown default:
            return "NSLayoutConstraint.Attribute.unknown"
        }
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
