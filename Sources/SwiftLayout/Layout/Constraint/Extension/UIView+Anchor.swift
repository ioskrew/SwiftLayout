//
//  UIView+Anchor.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

extension UIView {
    func attribute<Anchor>(_ anchor: Anchor) -> NSLayoutConstraint.Attribute where Anchor: NSLayoutAnchorConstraint {
        if self.topAnchor.isEqual(anchor) {
            return .top
        } else if self.bottomAnchor.isEqual(anchor) {
            return .bottom
        } else if self.leadingAnchor.isEqual(anchor) {
            return .leading
        } else if self.trailingAnchor.isEqual(anchor) {
            return .trailing
        } else if self.leftAnchor.isEqual(anchor) {
            return .left
        } else if self.rightAnchor.isEqual(anchor) {
            return .right
        } else if self.widthAnchor.isEqual(anchor) {
            return .width
        } else if self.heightAnchor.isEqual(anchor) {
            return .height
        } else if self.centerXAnchor.isEqual(anchor) {
            return .centerX
        } else if self.centerYAnchor.isEqual(anchor) {
            return .centerY
        } else if self.firstBaselineAnchor.isEqual(anchor) {
            return .firstBaseline
        } else if self.lastBaselineAnchor.isEqual(anchor) {
            return .lastBaseline
        } else {
            return .notAnAttribute
        }
    }
}

extension UILayoutGuide {
    func attribute<Anchor>(_ anchor: Anchor) -> NSLayoutConstraint.Attribute where Anchor: NSLayoutAnchorConstraint {
        if self.topAnchor.isEqual(anchor) {
            return .top
        } else if self.bottomAnchor.isEqual(anchor) {
            return .bottom
        } else if self.leadingAnchor.isEqual(anchor) {
            return .leading
        } else if self.trailingAnchor.isEqual(anchor) {
            return .trailing
        } else if self.leftAnchor.isEqual(anchor) {
            return .left
        } else if self.rightAnchor.isEqual(anchor) {
            return .right
        } else if self.widthAnchor.isEqual(anchor) {
            return .width
        } else if self.heightAnchor.isEqual(anchor) {
            return .height
        } else if self.centerXAnchor.isEqual(anchor) {
            return .centerX
        } else if self.centerYAnchor.isEqual(anchor) {
            return .centerY
        } else {
            return .notAnAttribute
        }
    }
    
}
