//
//  SwiftLayoutPlatform.swift
//  SwiftLayoutPlatform
//
//  Created for platform abstraction.
//

#if canImport(UIKit)
@_exported import UIKit
public typealias SLView = UIView
public typealias SLLayoutGuide = UILayoutGuide
public typealias SLStackView = UIStackView
public typealias SLVisualEffectView = UIVisualEffectView
public typealias SLLayoutPriority = UILayoutPriority

#elseif canImport(AppKit)
@_exported import AppKit
public typealias SLView = NSView
public typealias SLLayoutGuide = NSLayoutGuide
public typealias SLStackView = NSStackView
public typealias SLVisualEffectView = NSVisualEffectView
public typealias SLLayoutPriority = NSLayoutConstraint.Priority

#endif
