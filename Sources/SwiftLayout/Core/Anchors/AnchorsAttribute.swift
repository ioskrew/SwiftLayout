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
}


public enum AnchorsXAxisAttribute: AnchorsAttribute {
    case centerX
    case leading
    case left
    case right
    case trailing
    
    public init?(attribute: NSLayoutConstraint.Attribute) {
        switch attribute {
        case .centerX: self = .centerX
        case .leading: self = .leading
        case .left: self = .left
        case .right: self = .right
        case .trailing: self = .trailing
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
        }
    }
}

public enum AnchorsYAxisAttribute: AnchorsAttribute {
    case centerY
    case firstBaseline
    case lastBaseline
    case top
    case bottom
    
    public init?(attribute: NSLayoutConstraint.Attribute) {
        switch attribute {
        case .bottom: self = .bottom
        case .centerY: self = .centerY
        case .firstBaseline: self = .firstBaseline
        case .lastBaseline: self = .lastBaseline
        case .top: self = .top
        default: return nil
        }
    }
    
    public var attribute: NSLayoutConstraint.Attribute {
        switch self {
        case .bottom: return .bottom
        case .centerY: return .centerY
        case .firstBaseline: return .firstBaseline
        case .lastBaseline: return .lastBaseline
        case .top: return .top
        }
    }
}

public enum AnchorsDimensionAttribute: AnchorsAttribute {
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
}
