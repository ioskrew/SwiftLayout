//
//  Anchors+LayoutGuide.swift
//  
//
//  Created by oozoofrog on 2022/03/20.
//

import UIKit

extension Anchors {
    
    ///
    /// Set constraint attributes of ``Anchors`` with `NSLayoutAnchor`
    ///
    /// - Parameter layoutAnchor: A layout anchor from a `UIView` or `UILayoutGuide` object.
    /// - Returns: ``Anchors``
    ///
    public func equalTo(_ layoutAnchor: NSLayoutXAxisAnchor) -> Self {
        let target = constraintTargetWithConstant(layoutAnchor)
        return to(.equal, to: target)
    }
    
    ///
    /// Set constraint attributes of ``Anchors`` with `NSLayoutAnchor`
    ///
    /// - Parameter layoutAnchor: A layout anchor from a `UIView` or `UILayoutGuide` object.
    /// - Returns: ``Anchors``
    ///
    public func equalTo(_ layoutAnchor: NSLayoutYAxisAnchor) -> Self {
        let target = constraintTargetWithConstant(layoutAnchor)
        return to(.equal, to: target)
    }
    
    ///
    /// Set constraint attributes of ``Anchors`` with `NSLayoutAnchor`
    ///
    /// - Parameter layoutAnchor: A layout anchor from a `UIView` or `UILayoutGuide` object.
    /// - Returns: ``Anchors``
    ///
    public func equalTo(_ layoutAnchor: NSLayoutDimension) -> Self {
        let target = constraintTargetWithConstant(layoutAnchor)
        return to(.equal, to: target)
    }
    
    ///
    /// Set constraint attributes of ``Anchors`` with `NSLayoutAnchor`
    ///
    /// - Parameter layoutAnchor: A layout anchor from a `UIView` or `UILayoutGuide` object.
    /// - Returns: ``Anchors``
    ///
    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutXAxisAnchor) -> Self {
        let target = constraintTargetWithConstant(layoutAnchor)
        return to(.greaterThanOrEqual, to: target)
    }
    
    ///
    /// Set constraint attributes of ``Anchors`` with `NSLayoutAnchor`
    ///
    /// - Parameter layoutAnchor: A layout anchor from a `UIView` or `UILayoutGuide` object.
    /// - Returns: ``Anchors``
    ///
    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutYAxisAnchor) -> Self {
        let target = constraintTargetWithConstant(layoutAnchor)
        return to(.greaterThanOrEqual, to: target)
    }
    
    ///
    /// Set constraint attributes of ``Anchors`` with `NSLayoutAnchor`
    ///
    /// - Parameter layoutAnchor: A layout anchor from a `UIView` or `UILayoutGuide` object.
    /// - Returns: ``Anchors``
    ///
    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutDimension) -> Self {
        let target = constraintTargetWithConstant(layoutAnchor)
        return to(.greaterThanOrEqual, to: target)
    }
    
    ///
    /// Set constraint attributes of ``Anchors`` with `NSLayoutAnchor`
    ///
    /// - Parameter layoutAnchor: A layout anchor from a `UIView` or `UILayoutGuide` object.
    /// - Returns: ``Anchors``
    ///
    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutXAxisAnchor) -> Self {
        let target = constraintTargetWithConstant(layoutAnchor)
        return to(.lessThanOrEqual, to: target)
    }
    
    ///
    /// Set constraint attributes of ``Anchors`` with `NSLayoutAnchor`
    ///
    /// - Parameter layoutAnchor: A layout anchor from a `UIView` or `UILayoutGuide` object.
    /// - Returns: ``Anchors``
    ///
    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutYAxisAnchor) -> Self {
        let target = constraintTargetWithConstant(layoutAnchor)
        return to(.lessThanOrEqual, to: target)
    }
    
    ///
    /// Set constraint attributes of ``Anchors`` with `NSLayoutAnchor`
    ///
    /// - Parameter layoutAnchor: A layout anchor from a `UIView` or `UILayoutGuide` object.
    /// - Returns: ``Anchors``
    ///
    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutDimension) -> Self {
        let target = constraintTargetWithConstant(layoutAnchor)
        return to(.lessThanOrEqual, to: target)
    }
    
    private func constraintTargetWithConstant(_ layoutAnchor: NSLayoutXAxisAnchor) -> Anchors.ConstraintTarget {
        targetFromConstraint(UIView().leadingAnchor.constraint(equalTo: layoutAnchor))
    }
    
    private func constraintTargetWithConstant(_ layoutAnchor: NSLayoutYAxisAnchor) -> Anchors.ConstraintTarget {
        targetFromConstraint(UIView().topAnchor.constraint(equalTo: layoutAnchor))
    }
    
    private func constraintTargetWithConstant(_ layoutAnchor: NSLayoutDimension) -> Anchors.ConstraintTarget {
        targetFromConstraint(UIView().widthAnchor.constraint(equalTo: layoutAnchor))
    }
    
    private func targetFromConstraint(_ constraint: NSLayoutConstraint) -> Anchors.ConstraintTarget {
        if let object = constraint.secondItem as? NSObject {
            return .init(item: .object(object), attribute: constraint.secondAttribute, constant: .zero)
        } else {
            return .init(item: .transparent, attribute: constraint.secondAttribute, constant: .zero)
        }
    }
}
