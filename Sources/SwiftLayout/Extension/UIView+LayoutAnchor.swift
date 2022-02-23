//
//  UIView+LayoutAnchor.swift
//  
//
//  Created by oozoofrog on 2022/02/22.
//

import Foundation
import UIKit

extension LayoutAnchor where Self: NSObject {
    var item: NSObject? {
        let value = value(forKey: ["i", "t", "e", "m"].joined(separator: ""))
        if value is NSObject {
            return value as? NSObject
        } else {
            return nil
        }
    }
    var view: UIView? {
        if item is UIView {
            return item as? UIView
        } else {
            return nil
        }
    }
    
    var layoutGuide: UILayoutGuide? {
        if item is UILayoutGuide {
            return item as? UILayoutGuide
        } else {
            return nil
        }
    }
    
    func constraintTargetWithConstant(_ constant: CGFloat) -> Anchors.ConstraintTarget? {
        if let view = view {
            return Anchors.ConstraintTarget(item: view, attribute: view.attributeFromAnchor(self), constant: constant)
        } else if let layoutGuide = layoutGuide {
            return Anchors.ConstraintTarget(item: layoutGuide, attribute: layoutGuide.attributeFromAnchor(self), constant: constant)
        } else {
            return nil
        }
    }
}

extension UIView {
    func attributeFromAnchor<LA: LayoutAnchor&NSObject>(_ anchor: LA) -> NSLayoutConstraint.Attribute {
        if self.topAnchor == anchor {
            return .top
        } else if self.bottomAnchor == anchor {
            return .bottom
        } else if self.leadingAnchor == anchor {
            return .leading
        } else if self.trailingAnchor == anchor {
            return .trailing
        } else if self.leftAnchor == anchor {
            return .left
        } else if self.rightAnchor == anchor {
            return .right
        } else if self.centerXAnchor == anchor {
            return .centerX
        } else if self.centerYAnchor == anchor {
            return .centerY
        } else if self.widthAnchor == anchor {
            return .width
        } else if self.heightAnchor == anchor {
            return .height
        } else if self.firstBaselineAnchor == anchor {
            return .firstBaseline
        } else if self.lastBaselineAnchor == anchor {
            return .lastBaseline
        } else {
            return .notAnAttribute
        }
    }
}

extension UILayoutGuide {
    func attributeFromAnchor<LA: LayoutAnchor&NSObject>(_ anchor: LA) -> NSLayoutConstraint.Attribute {
        if self.topAnchor == anchor {
            return .top
        } else if self.bottomAnchor == anchor {
            return .bottom
        } else if self.leadingAnchor == anchor {
            return .leading
        } else if self.trailingAnchor == anchor {
            return .trailing
        } else if self.leftAnchor == anchor {
            return .left
        } else if self.rightAnchor == anchor {
            return .right
        } else if self.centerXAnchor == anchor {
            return .centerX
        } else if self.centerYAnchor == anchor {
            return .centerY
        } else if self.widthAnchor == anchor {
            return .width
        } else if self.heightAnchor == anchor {
            return .height
        } else {
            return .notAnAttribute
        }
    }
}
