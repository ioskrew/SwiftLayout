//
//  View+Kit.swift
//  
//
//  Created by oozoofrog on 2022/03/11.
//

import Foundation

#if canImport(UIKit)
import UIKit
typealias SLWindow = UIWindow
typealias SLView = UIView
typealias SLLayoutGuide = UILayoutGuide
typealias SLViewController = UIViewController
typealias SLLayoutConstraint = NSLayoutConstraint
typealias SLLayoutXAxisAnchor = NSLayoutXAxisAnchor
typealias SLLayoutYAxisAnchor = NSLayoutYAxisAnchor
typealias SLLayoutDimension = NSLayoutDimension
#if canImport(SwiftUI)
import SwiftUI
typealias SLViewRepresentable = UIViewRepresentable
typealias SLViewRepresentableContext = UIViewRepresentableContext
typealias SLViewControllerRepresentable = UIViewControllerRepresentable
typealias SLViewControllerRepresentableContext = UIViewControllerRepresentableContext
#endif
#elseif canImport(AppKit)
import AppKit
typealias SLWindow = NSWindow
typealias SLView = NSView
typealias SLLayoutGuide = NSLayoutGuide
typealias SLViewController = NSViewController
typealias SLLayoutConstraint = NSLayoutConstraint
typealias SLLayoutXAxisAnchor = NSLayoutXAxisAnchor
typealias SLLayoutYAxisAnchor = NSLayoutYAxisAnchor
typealias SLLayoutDimension = NSLayoutDimension
#if canImport(SwiftUI)
import SwiftUI
typealias SLViewRepresentable = NSViewRepresentable
typealias SLViewRepresentableContext = NSViewRepresentableContext
typealias SLViewControllerRepresentable = NSViewControllerRepresentable
typealias SLViewControllerRepresentableContext = NSViewControllerRepresentableContext
#endif
#endif

#if canImport(UIKit)
extension SLView {
    func slLayout() {
        setNeedsLayout()
        layoutIfNeeded()
    }
    var slIdentifier: String? {
        get { accessibilityIdentifier }
        set { accessibilityIdentifier = newValue }
    }
}
#elseif canImport(AppKit)
extension SLView {
    func slLayout() {
        layoutSubtreeIfNeeded()
    }
    var slIdentifier: String? {
        get { accessibilityIdentifier() }
        set {
            if let identifier = newValue {
                self.identifier = .init(identifier)
            }
            setAccessibilityIdentifier(newValue)
        }
    }
}
#endif
