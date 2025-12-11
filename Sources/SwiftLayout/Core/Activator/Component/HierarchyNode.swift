//
//  HierarchyNode.swift
//  SwiftLayout
//
//  Created by aiden_h on 8/1/25.
//

import UIKit

// MARK: - HierarchyNodable Protocol

/// Protocol for types that can participate in view hierarchy.
/// Use `any HierarchyNodable` to store heterogeneous hierarchy nodes in collections.
@MainActor
protocol HierarchyNodable: AnyObject {
    var nodeIdentifier: String? { get }
    var baseObject: NSObject? { get }
    /// Object identifier of the base view/guide, captured at init for nonisolated hash access.
    nonisolated var baseObjectIdentifier: ObjectIdentifier { get }

    func updateTranslatesAutoresizingMaskIntoConstraints()
    func addToSuperview(_ superview: UIView?, option: LayoutOption)
    func removeFromSuperview(_ superview: UIView?)

    func forceLayout()
    func removeSizeAndPositionAnimation()
}

// MARK: - ViewNode (Wrapper for UIView)

/// A class wrapper that holds UIView weakly and provides hierarchy operations.
@MainActor
final class ViewNode<View: UIView>: HierarchyNodable {
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

    func addToSuperview(_ superview: UIView?, option: LayoutOption) {
        guard let base else { return }
        if let stackView = superview as? UIStackView, !option.contains(.isNotArranged) {
            stackView.addArrangedSubview(base)
        } else if let visualEffectView = superview as? UIVisualEffectView {
            visualEffectView.contentView.addSubview(base)
        } else {
            superview?.addSubview(base)
        }
    }

    func removeFromSuperview(_ superview: UIView?) {
        guard let base else { return }
        if let visualEffectView = superview as? UIVisualEffectView {
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

// MARK: - GuideNode (Wrapper for UILayoutGuide)

/// A class wrapper that holds UILayoutGuide weakly and provides hierarchy operations.
@MainActor
final class GuideNode<Guide: UILayoutGuide>: HierarchyNodable {
    weak var base: Guide?
    nonisolated let baseObjectIdentifier: ObjectIdentifier

    init(_ base: Guide) {
        self.base = base
        self.baseObjectIdentifier = ObjectIdentifier(base)
    }

    var baseObject: NSObject? { base }

    var nodeIdentifier: String? { base?.identifier }

    func updateTranslatesAutoresizingMaskIntoConstraints() {
        // UILayoutGuide does not have translatesAutoresizingMaskIntoConstraints
    }

    func addToSuperview(_ superview: UIView?, option: LayoutOption) {
        guard let base else { return }
        if let visualEffectView = superview as? UIVisualEffectView {
            visualEffectView.contentView.addLayoutGuide(base)
        } else {
            superview?.addLayoutGuide(base)
        }
    }

    func removeFromSuperview(_ superview: UIView?) {
        guard let base else { return }
        if let visualEffectView = superview as? UIVisualEffectView {
            guard visualEffectView.contentView == base.owningView else { return }
            visualEffectView.contentView.removeLayoutGuide(base)
        } else {
            guard superview == base.owningView else { return }
            superview?.removeLayoutGuide(base)
        }
    }

    func forceLayout() {
        // UILayoutGuide does not need force layout
    }

    func removeSizeAndPositionAnimation() {
        // UILayoutGuide does not have animations
    }
}
