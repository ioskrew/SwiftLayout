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
        superview?.addSubview(self)

        if let stackSuperView = superview as? UIStackView, option.contains(.isNotArranged) == false {
            stackSuperView.addArrangedSubview(self)
        }
    }

    func removeFromSuperview(_ superview: UIView?) {
        guard superview == self.superview else { return }
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
        superview?.addLayoutGuide(self)
    }

    func removeFromSuperview(_ superview: UIView?) {
        guard superview == self.owningView else {
            return
        }

        superview?.removeLayoutGuide(self)
    }

    func forceLayout() {
    }

    func removeSizeAndPositionAnimation() {
    }
}
