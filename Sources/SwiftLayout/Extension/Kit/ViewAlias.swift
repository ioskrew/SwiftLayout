//
//  View+Kit.swift
//  
//
//  Created by oozoofrog on 2022/03/11.
//

import Foundation

#if canImport(AppKit)
import AppKit
public typealias UIView = AppKit.NSView
public typealias UILayoutGuide = AppKit.NSLayoutGuide
public typealias UIViewController = AppKit.NSViewController
#if canImport(SwiftUI)
import SwiftUI
public typealias UIViewRepresentable = SwiftUI.NSViewRepresentable
public typealias UIViewRepresentableContext = SwiftUI.NSViewRepresentableContext
public typealias UIViewControllerRepresentable = SwiftUI.NSViewControllerRepresentable
public typealias UIViewControllerRepresentableContext = SwiftUI.NSViewControllerRepresentableContext
#endif

extension NSView {
    public func setNeedsLayout() {}
    public func layoutIfNeeded() {
        layoutSubtreeIfNeeded()
    }
}

#endif
