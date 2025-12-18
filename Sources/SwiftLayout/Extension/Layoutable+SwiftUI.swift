//
//  Layoutable+SwiftUI.swift
//
//
//  Created by oozoofrog on 2022/04/01.
//

import SwiftUI
import SwiftLayoutPlatform

#if canImport(UIKit)

public extension LayoutMethodWrapper where Base: Layoutable & UIView {
    var swiftUI: SLViewRepresentable<Base> {
        SLViewRepresentable(base)
    }
}

public extension LayoutMethodWrapper where Base: Layoutable & UIViewController {
    var swiftUI: SLViewControllerRepresentable<Base> {
        SLViewControllerRepresentable(base)
    }
}

public struct SLViewRepresentable<L: Layoutable & UIView>: UIViewRepresentable {
    let layoutable: L

    init(_ layoutable: L) {
        self.layoutable = layoutable
    }

    public func makeUIView(context: Context) -> L {
        layoutable
    }

    public func updateUIView(_ uiView: L, context: Context) {
        layoutable.sl.updateLayout()
    }
}

public struct SLViewControllerRepresentable<L: Layoutable & UIViewController>: UIViewControllerRepresentable {
    let layoutable: L

    init(_ layoutable: L) {
        self.layoutable = layoutable
    }

    public func makeUIViewController(context: Context) -> L {
        layoutable
    }

    public func updateUIViewController(_ uiViewController: L, context: Context) {
        uiViewController.sl.updateLayout()
    }
}

#elseif canImport(AppKit)

public extension LayoutMethodWrapper where Base: Layoutable & NSView {
    var swiftUI: SLViewRepresentable<Base> {
        SLViewRepresentable(base)
    }
}

public extension LayoutMethodWrapper where Base: Layoutable & NSViewController {
    var swiftUI: SLViewControllerRepresentable<Base> {
        SLViewControllerRepresentable(base)
    }
}

public struct SLViewRepresentable<L: Layoutable & NSView>: NSViewRepresentable {
    let layoutable: L

    init(_ layoutable: L) {
        self.layoutable = layoutable
    }

    public func makeNSView(context: Context) -> L {
        layoutable
    }

    public func updateNSView(_ nsView: L, context: Context) {
        layoutable.sl.updateLayout()
    }
}

public struct SLViewControllerRepresentable<L: Layoutable & NSViewController>: NSViewControllerRepresentable {
    let layoutable: L

    init(_ layoutable: L) {
        self.layoutable = layoutable
    }

    public func makeNSViewController(context: Context) -> L {
        layoutable
    }

    public func updateNSViewController(_ nsViewController: L, context: Context) {
        nsViewController.sl.updateLayout()
    }
}

#endif
