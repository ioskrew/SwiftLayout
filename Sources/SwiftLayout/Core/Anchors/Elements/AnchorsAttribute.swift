//
//  AnchorsAttribute.swift
//
//
//  Created by aiden_h on 2022/03/27.
//

import SwiftLayoutPlatform

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
    #if canImport(UIKit)
    case centerXWithinMargins
    case leftMargin
    case rightMargin
    case leadingMargin
    case trailingMargin
    #endif

    public init?(attribute: NSLayoutConstraint.Attribute) {
        switch attribute {
        case .centerX: self = .centerX
        case .leading: self = .leading
        case .trailing: self = .trailing
        case .left: self = .left
        case .right: self = .right
        #if canImport(UIKit)
        case .centerXWithinMargins: self = .centerXWithinMargins
        case .leftMargin: self = .leftMargin
        case .rightMargin: self = .rightMargin
        case .leadingMargin: self = .leadingMargin
        case .trailingMargin: self = .trailingMargin
        #endif
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
        #if canImport(UIKit)
        case .centerXWithinMargins: return .centerXWithinMargins
        case .leftMargin: return .leftMargin
        case .rightMargin: return .rightMargin
        case .leadingMargin: return .leadingMargin
        case .trailingMargin: return .trailingMargin
        #endif
        }
    }

    public var inwardDirectionFactor: CGFloat {
        switch self {
        #if canImport(UIKit)
        case .right, .trailing, .rightMargin, .trailingMargin:
            return -1.0
        #else
        case .right, .trailing:
            return -1.0
        #endif
        default:
            return 1.0
        }
    }
}

public enum AnchorsYAxisAttribute: AnchorsAttribute, Sendable {
    case centerY
    case top
    case bottom
    case firstBaseline
    case lastBaseline
    #if canImport(UIKit)
    case centerYWithinMargins
    case topMargin
    case bottomMargin
    #endif

    public init?(attribute: NSLayoutConstraint.Attribute) {
        switch attribute {
        case .centerY: self = .centerY
        case .top: self = .top
        case .bottom: self = .bottom
        case .firstBaseline: self = .firstBaseline
        case .lastBaseline: self = .lastBaseline
        #if canImport(UIKit)
        case .centerYWithinMargins: self = .centerYWithinMargins
        case .topMargin: self = .topMargin
        case .bottomMargin: self = .bottomMargin
        #endif
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
        #if canImport(UIKit)
        case .centerYWithinMargins: return .centerYWithinMargins
        case .topMargin: return .topMargin
        case .bottomMargin: return .bottomMargin
        #endif
        }
    }

    public var inwardDirectionFactor: CGFloat {
        switch self {
        #if canImport(UIKit)
        case .bottom, .bottomMargin:
            return -1.0
        #else
        case .bottom:
            return -1.0
        #endif
        default:
            return 1.0
        }
    }
}

public enum AnchorsDimensionAttribute: AnchorsAttribute, Sendable {
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
