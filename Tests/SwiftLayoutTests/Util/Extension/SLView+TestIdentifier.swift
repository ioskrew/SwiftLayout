//
//  SLView+TestIdentifier.swift
//  SwiftLayoutTests
//

import SwiftLayoutPlatform

extension SLView {
    @MainActor
    func withIdentifier(_ id: String) -> Self {
        #if canImport(UIKit)
        accessibilityIdentifier = id
        #else
        setAccessibilityIdentifier(id)
        #endif
        return self
    }

    @MainActor
    var testIdentifier: String? {
        #if canImport(UIKit)
        return accessibilityIdentifier
        #else
        return accessibilityIdentifier()
        #endif
    }

    @MainActor
    func slLayoutIfNeeded() {
        #if canImport(UIKit)
        layoutIfNeeded()
        #else
        layoutSubtreeIfNeeded()
        #endif
    }

    @MainActor
    func slSetNeedsLayout() {
        #if canImport(UIKit)
        setNeedsLayout()
        #else
        needsLayout = true
        #endif
    }
}

extension SLLayoutGuide {
    @MainActor
    func withIdentifier(_ id: String) -> Self {
        #if canImport(UIKit)
        identifier = id
        #else
        identifier = NSUserInterfaceItemIdentifier(rawValue: id)
        #endif
        return self
    }

    @MainActor
    var testIdentifier: String {
        #if canImport(UIKit)
        return identifier
        #else
        return identifier.rawValue
        #endif
    }
}
