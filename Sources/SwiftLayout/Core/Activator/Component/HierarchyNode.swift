//
//  HierarchyNode.swift
//  SwiftLayout
//
//  Created by aidne_h on 8/1/25.
//

import UIKit

@MainActor
protocol HierarchyNode: NSObject, Hashable {
    var nodeIdentifier: String? { get }

    func updateTranslatesAutoresizingMaskIntoConstraints()
    func addToSuperview(_ superview: UIView?, option: LayoutOption)
    func removeFromSuperview(_ superview: UIView?)

    func forceLayout()
    func removeSizeAndPositionAnimation()
}

extension UIView: HierarchyNode {

    var nodeIdentifier: String? {
        accessibilityIdentifier
    }

    func updateTranslatesAutoresizingMaskIntoConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    func addToSuperview(_ superview: UIView?, option: LayoutOption) {
        if let stackView = superview as? UIStackView, !option.contains(.isNotArranged) {
            stackView.addArrangedSubview(self)
        } else if let visualEffectView = superview as? UIVisualEffectView {
            visualEffectView.contentView.addSubview(self)
        } else {
            superview?.addSubview(self)
        }
    }

    func removeFromSuperview(_ superview: UIView?) {
        if let visualEffectView = superview as? UIVisualEffectView {
            guard visualEffectView.contentView == self.superview else { return }
        } else {
            guard superview == self.superview else { return }
        }
        self.removeFromSuperview()
    }

    func forceLayout() {
        setNeedsLayout()
        layoutIfNeeded()
    }

    func removeSizeAndPositionAnimation() {
        layer.removeAnimation(forKey: "bounds.size")
        layer.removeAnimation(forKey: "position")
    }
}
extension UILayoutGuide: HierarchyNode {
    var nodeIdentifier: String? {
        identifier
    }

    func updateTranslatesAutoresizingMaskIntoConstraints() {
    }

    func addToSuperview(_ superview: UIView?, option: LayoutOption) {
        if let visualEffectView = superview as? UIVisualEffectView {
            visualEffectView.contentView.addLayoutGuide(self)
        } else {
            superview?.addLayoutGuide(self)
        }
    }

    func removeFromSuperview(_ superview: UIView?) {
        if let visualEffectView = superview as? UIVisualEffectView {
            guard visualEffectView.contentView == self.owningView else { return }
            visualEffectView.contentView.removeLayoutGuide(self)
        } else {
            guard superview == self.owningView else { return }
            superview?.removeLayoutGuide(self)
        }
    }

    func forceLayout() {
    }

    func removeSizeAndPositionAnimation() {
    }
}
