//
//  AnchorsAttribute.swift
//  
//
//  Created by aiden_h on 2022/03/27.
//

import UIKit

public protocol AnchorsAttribute {
    init?(attribute: NSLayoutConstraint.Attribute)
    var attribute: NSLayoutConstraint.Attribute { get }
    var inwardDirectionFactor: CGFloat { get }
}

public enum AnchorsXAxisAttribute: AnchorsAttribute, Sendable {
    case centerX
    case leading
    case trailing
    case left
    case right
    case centerXWithinMargins
    case leftMargin
    case rightMargin
    case leadingMargin
    case trailingMargin
    
    
    public init?(attribute: NSLayoutConstraint.Attribute) {
        switch attribute {
        case .centerX: self = .centerX
        case .leading: self = .leading
        case .trailing: self = .trailing
        case .left: self = .left
        case .right: self = .right
        case .centerXWithinMargins: self = .centerXWithinMargins
        case .leftMargin: self = .leftMargin
        case .rightMargin: self = .rightMargin
        case .leadingMargin: self = .leadingMargin
        case .trailingMargin: self = .trailingMargin
        default: return nil
        }
    }
    
    public var attribute: NSLayoutConstraint.Attribute {
        switch self {
        case .centerX: return .centerX
        case .leading: return .leading
        case .left: return .left
        case .right: return .right
        case .trailing: return .trailing
        case .centerXWithinMargins: return .centerXWithinMargins
        case .leftMargin: return .leftMargin
        case .rightMargin: return .rightMargin
        case .leadingMargin: return .leadingMargin
        case .trailingMargin: return .trailingMargin
        }
    }

    public var inwardDirectionFactor: CGFloat {
        switch self {
        case .right, .trailing, .rightMargin, .trailingMargin:
            return -1.0
        default:
            return 1.0
        }
    }
}

public enum AnchorsYAxisAttribute: AnchorsAttribute, Sendable  {
    case centerY
    case top
    case bottom
    case firstBaseline
    case lastBaseline
    case centerYWithinMargins
    case topMargin
    case bottomMargin
    
    
    public init?(attribute: NSLayoutConstraint.Attribute) {
        switch attribute {
        case .centerY: self = .centerY
        case .top: self = .top
        case .bottom: self = .bottom
        case .firstBaseline: self = .firstBaseline
        case .lastBaseline: self = .lastBaseline
        case .centerYWithinMargins: self = .centerYWithinMargins
        case .topMargin: self = .topMargin
        case .bottomMargin: self = .bottomMargin
        default: return nil
        }
    }
    
    public var attribute: NSLayoutConstraint.Attribute {
        switch self {
        case .centerY: return .centerY
        case .top: return .top
        case .bottom: return .bottom
        case .firstBaseline: return .firstBaseline
        case .lastBaseline: return .lastBaseline
        case .centerYWithinMargins: return .centerYWithinMargins
        case .topMargin: return .topMargin
        case .bottomMargin: return .bottomMargin
        }
    }

    public var inwardDirectionFactor: CGFloat {
        switch self {
        case .bottom, .bottomMargin:
            return -1.0
        default:
            return 1.0
        }
    }
}

public enum AnchorsDimensionAttribute: AnchorsAttribute, Sendable  {
    case height
    case width
    
    public init?(attribute: NSLayoutConstraint.Attribute) {
        switch attribute {
        case .height: self = .height
        case .width: self = .width
        default: return nil
        }
    }
    
    public var attribute: NSLayoutConstraint.Attribute {
        switch self {
        case .height: return .height
        case .width: return .width
        }
    }

    public var inwardDirectionFactor: CGFloat {
        switch self {
        default:
            return 1.0
        }
    }
}
