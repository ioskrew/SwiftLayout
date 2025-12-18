//
//  HierarchyNode.swift
//  SwiftLayout
//
//  Created by aiden_h on 8/1/25.
//

import SwiftLayoutPlatform

// MARK: - HierarchyNodable Protocol

/// Protocol for types that can participate in view hierarchy.
@MainActor
protocol HierarchyNodable: AnyObject {
    var nodeIdentifier: String? { get }
    var baseObject: NSObject? { get }
    nonisolated var baseObjectIdentifier: ObjectIdentifier { get }

    func updateTranslatesAutoresizingMaskIntoConstraints()
    func addToSuperview(_ superview: SLView?, option: LayoutOption)
    func removeFromSuperview(_ superview: SLView?)
    func forceLayout()
    func removeSizeAndPositionAnimation()
}

// MARK: - Platform-specific implementations

#if canImport(UIKit)

// MARK: - iOS ViewNode

@MainActor
final class ViewNode<View: SLView>: HierarchyNodable {
    weak var base: View?
    nonisolated let baseObjectIdentifier: ObjectIdentifier

    init(_ base: View) {
        self.base = base
        self.baseObjectIdentifier = ObjectIdentifier(base)
    }

    var baseObject: NSObject? { base }
    var nodeIdentifier: String? { base?.accessibilityIdentifier }

    func updateTranslatesAutoresizingMaskIntoConstraints() {
        base?.translatesAutoresizingMaskIntoConstraints = false
    }

    func addToSuperview(_ superview: SLView?, option: LayoutOption) {
        guard let base else { return }
        if let stackView = superview as? SLStackView, !option.contains(.isNotArranged) {
            stackView.addArrangedSubview(base)
        } else if let visualEffectView = superview as? SLVisualEffectView {
            visualEffectView.contentView.addSubview(base)
        } else {
            superview?.addSubview(base)
        }
    }

    func removeFromSuperview(_ superview: SLView?) {
        guard let base else { return }
        if let visualEffectView = superview as? SLVisualEffectView {
            guard visualEffectView.contentView == base.superview else { return }
        } else {
            guard superview == base.superview else { return }
        }
        base.removeFromSuperview()
    }

    func forceLayout() {
        base?.setNeedsLayout()
        base?.layoutIfNeeded()
    }

    func removeSizeAndPositionAnimation() {
        base?.layer.removeAnimation(forKey: "bounds.size")
        base?.layer.removeAnimation(forKey: "position")
    }
}

// MARK: - iOS GuideNode

@MainActor
final class GuideNode<Guide: SLLayoutGuide>: HierarchyNodable {
    weak var base: Guide?
    nonisolated let baseObjectIdentifier: ObjectIdentifier

    init(_ base: Guide) {
        self.base = base
        self.baseObjectIdentifier = ObjectIdentifier(base)
    }

    var baseObject: NSObject? { base }
    var nodeIdentifier: String? { base?.identifier }

    func updateTranslatesAutoresizingMaskIntoConstraints() {}

    func addToSuperview(_ superview: SLView?, option: LayoutOption) {
        guard let base else { return }
        if let visualEffectView = superview as? SLVisualEffectView {
            visualEffectView.contentView.addLayoutGuide(base)
        } else {
            superview?.addLayoutGuide(base)
        }
    }

    func removeFromSuperview(_ superview: SLView?) {
        guard let base else { return }
        if let visualEffectView = superview as? SLVisualEffectView {
            guard visualEffectView.contentView == base.owningView else { return }
            visualEffectView.contentView.removeLayoutGuide(base)
        } else {
            guard superview == base.owningView else { return }
            superview?.removeLayoutGuide(base)
        }
    }

    func forceLayout() {}
    func removeSizeAndPositionAnimation() {}
}

#else

// MARK: - macOS ViewNode

@MainActor
final class ViewNode<View: SLView>: HierarchyNodable {
    weak var base: View?
    nonisolated let baseObjectIdentifier: ObjectIdentifier

    init(_ base: View) {
        self.base = base
        self.baseObjectIdentifier = ObjectIdentifier(base)
    }

    var baseObject: NSObject? { base }
    var nodeIdentifier: String? {
        guard let id = base?.accessibilityIdentifier(), !id.isEmpty else { return nil }
        return id
    }

    func updateTranslatesAutoresizingMaskIntoConstraints() {
        base?.translatesAutoresizingMaskIntoConstraints = false
    }

    func addToSuperview(_ superview: SLView?, option: LayoutOption) {
        guard let base else { return }
        if let stackView = superview as? SLStackView, !option.contains(.isNotArranged) {
            stackView.addArrangedSubview(base)
        } else {
            superview?.addSubview(base)
        }
    }

    func removeFromSuperview(_ superview: SLView?) {
        guard let base else { return }
        guard superview == base.superview else { return }
        base.removeFromSuperview()
    }

    func forceLayout() {
        base?.needsLayout = true
        base?.layoutSubtreeIfNeeded()
    }

    func removeSizeAndPositionAnimation() {
        base?.layer?.removeAnimation(forKey: "bounds.size")
        base?.layer?.removeAnimation(forKey: "position")
    }
}

// MARK: - macOS GuideNode

@MainActor
final class GuideNode<Guide: SLLayoutGuide>: HierarchyNodable {
    weak var base: Guide?
    nonisolated let baseObjectIdentifier: ObjectIdentifier

    init(_ base: Guide) {
        self.base = base
        self.baseObjectIdentifier = ObjectIdentifier(base)
    }

    var baseObject: NSObject? { base }
    var nodeIdentifier: String? { base?.identifier.rawValue }

    func updateTranslatesAutoresizingMaskIntoConstraints() {}

    func addToSuperview(_ superview: SLView?, option: LayoutOption) {
        guard let base else { return }
        superview?.addLayoutGuide(base)
    }

    func removeFromSuperview(_ superview: SLView?) {
        guard let base else { return }
        guard superview == base.owningView else { return }
        superview?.removeLayoutGuide(base)
    }

    func forceLayout() {}
    func removeSizeAndPositionAnimation() {}
}

#endif
