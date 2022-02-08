//
//  UIView+Anchor.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

extension UIView {
    func anchor(for attribute: NSLayoutConstraint.Attribute) -> AnchorType {
        switch attribute {
        case .top:
            return topAnchor.anchorType
        case .bottom:
            return bottomAnchor.anchorType
        case .leading:
            return leadingAnchor.anchorType
        case .trailing:
            return trailingAnchor.anchorType
        case .left:
            return leftAnchor.anchorType
        case .right:
            return rightAnchor.anchorType
        case .width:
            return widthAnchor.anchorType
        case .height:
            return heightAnchor.anchorType
        case .centerX:
            return centerXAnchor.anchorType
        case .centerY:
            return centerYAnchor.anchorType
        case .firstBaseline:
            return firstBaselineAnchor.anchorType
        case .lastBaseline:
            return lastBaselineAnchor.anchorType
        default:
            return .idontknow
        }
    }
}

extension UIView {
    func attribute<Anchor>(_ anchor: Anchor) -> NSLayoutConstraint.Attribute where Anchor: NSObject {
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
    func attribute<Anchor>(_ anchor: Anchor) -> NSLayoutConstraint.Attribute where Anchor: NSObject {
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
