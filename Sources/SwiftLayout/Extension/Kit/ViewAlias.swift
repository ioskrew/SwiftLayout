//
//  View+Kit.swift
//  
//
//  Created by oozoofrog on 2022/03/11.
//

import Foundation

#if canImport(UIKit)
import UIKit
public typealias SLView = UIView
public typealias SLLayoutGuide = UILayoutGuide
public typealias SLViewController = UIViewController
public typealias SLLayoutConstraint = NSLayoutConstraint
public typealias SLLayoutXAxisAnchor = NSLayoutXAxisAnchor
public typealias SLLayoutYAxisAnchor = NSLayoutYAxisAnchor
public typealias SLLayoutDimension = NSLayoutDimension
#if canImport(SwiftUI)
import SwiftUI
public typealias SLViewRepresentable = UIViewRepresentable
public typealias SLViewRepresentableContext = UIViewRepresentableContext
public typealias SLViewControllerRepresentable = UIViewControllerRepresentable
public typealias SLViewControllerRepresentableContext = UIViewControllerRepresentableContext
#endif
#elseif canImport(AppKit)
import AppKit
public typealias SLView = NSView
public typealias SLLayoutGuide = NSLayoutGuide
public typealias SLViewController = NSViewController
public typealias SLLayoutConstraint = NSLayoutConstraint
public typealias SLLayoutXAxisAnchor = NSLayoutXAxisAnchor
public typealias SLLayoutYAxisAnchor = NSLayoutYAxisAnchor
public typealias SLLayoutDimension = NSLayoutDimension
#if canImport(SwiftUI)
import SwiftUI
public typealias SLViewRepresentable = NSViewRepresentable
public typealias SLViewRepresentableContext = NSViewRepresentableContext
public typealias SLViewControllerRepresentable = NSViewControllerRepresentable
public typealias SLViewControllerRepresentableContext = NSViewControllerRepresentableContext
#endif

extension SLView {
    public func setNeedsLayout() {}
    public func layoutIfNeeded() {
        layoutSubtreeIfNeeded()
    }
}

#endif
