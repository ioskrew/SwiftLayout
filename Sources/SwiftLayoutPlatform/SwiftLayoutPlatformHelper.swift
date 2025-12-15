//
//  SLPlatformHelper.swift
//  SwiftLayoutPlatform
//

import Foundation

// MARK: - Animation Options

#if canImport(UIKit)
public typealias SLAnimationOptions = UIView.AnimationOptions
#else
public struct SLAnimationOptions: OptionSet, Sendable {
    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public static let curveEaseInOut = SLAnimationOptions(rawValue: 1 << 0)
    public static let curveEaseIn = SLAnimationOptions(rawValue: 1 << 1)
    public static let curveEaseOut = SLAnimationOptions(rawValue: 1 << 2)
    public static let curveLinear = SLAnimationOptions(rawValue: 1 << 3)

    package func toAppKitTimingFunction() -> CAMediaTimingFunction? {
        if contains(.curveEaseIn) {
            return CAMediaTimingFunction(name: .easeIn)
        } else if contains(.curveEaseOut) {
            return CAMediaTimingFunction(name: .easeOut)
        } else if contains(.curveLinear) {
            return CAMediaTimingFunction(name: .linear)
        } else {
            return CAMediaTimingFunction(name: .easeInEaseOut)
        }
    }
}
#endif

// MARK: - Platform Helper

package enum SwiftLayoutPlatformHelper {
    @MainActor
    package static func setViewIdentifier(_ view: SLView, _ identifier: String) {
        #if canImport(UIKit)
        view.accessibilityIdentifier = identifier
        #else
        view.setAccessibilityIdentifier(identifier)
        #endif
    }

    @MainActor
    package static func setGuideIdentifier(_ guide: SLLayoutGuide, _ identifier: String) {
        #if canImport(UIKit)
        guide.identifier = identifier
        #else
        guide.identifier = NSUserInterfaceItemIdentifier(rawValue: identifier)
        #endif
    }

    @MainActor
    package static func animate(
        duration: TimeInterval,
        delay: TimeInterval = 0,
        options: SLAnimationOptions = [],
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        #if canImport(UIKit)
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: options,
            animations: animations,
            completion: completion
        )
        #else
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                performMacOSAnimation(duration: duration, options: options, animations: animations, completion: completion)
            }
        } else {
            performMacOSAnimation(duration: duration, options: options, animations: animations, completion: completion)
        }
        #endif
    }

    #if canImport(AppKit)
    @MainActor
    private static func performMacOSAnimation(
        duration: TimeInterval,
        options: SLAnimationOptions,
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)?
    ) {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = duration
            context.allowsImplicitAnimation = true
            context.timingFunction = options.toAppKitTimingFunction()
            animations()
        } completionHandler: {
            completion?(true)
        }
    }
    #endif
}
