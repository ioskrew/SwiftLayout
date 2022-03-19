//
//  Anchors+Relation.swift
//  
//
//  Created by oozoofrog on 2022/03/20.
//

import UIKit

extension Anchors {

    ///
    /// Set constraint attributes of ``Anchors``
    ///
    /// - Parameter constant: Represents the `constant` property of `NSLayoutConstraint`.
    /// - Returns: ``Anchors``
    ///
    public func equalTo(constant: CGFloat) -> Self {
        to(.equal, to: .init(item: .deny, attribute: nil, constant: constant))
    }
    
    ///
    /// Set constraint attributes of ``Anchors``
    ///
    /// - Parameter constant: Represents the `constant` property of `NSLayoutConstraint`.
    /// - Returns: ``Anchors``
    ///
    public func greaterThanOrEqualTo(constant: CGFloat = .zero) -> Self {
        to(.greaterThanOrEqual, to: .init(item: .deny, attribute: nil, constant: constant))
    }
    
    ///
    /// Set constraint attributes of ``Anchors``
    ///
    /// - Parameter constant: Represents the `constant` property of `NSLayoutConstraint`.
    /// - Returns: ``Anchors``
    ///
    public func lessThanOrEqualTo(constant: CGFloat = .zero) -> Self {
        to(.lessThanOrEqual, to: .init(item: .deny, attribute: nil, constant: constant))
    }
    
    ///
    /// Set constraint attributes of ``Anchors``
    ///
    /// - Parameter toItem: Represents the `secondItem` property of `NSLayoutConstraint`. It will be UIView, UILayoutGuide, or identifier String.
    /// - Returns: ``Anchors``
    ///
    public func equalTo<I>(_ toItem: I) -> Self where I: ConstraintableItem {
        to(.equal, to: .init(item: toItem, attribute: nil, constant: .zero))
    }
    
    ///
    /// Set constraint attributes of ``Anchors``
    ///
    /// - Parameter toItem: Represents the `secondItem` property of `NSLayoutConstraint`. It will be UIView, UILayoutGuide, or identifier String.
    /// - Returns: ``Anchors``
    ///
    public func greaterThanOrEqualTo<I>(_ toItem: I) -> Self where I: ConstraintableItem {
        to(.greaterThanOrEqual, to: .init(item: toItem, attribute: nil, constant: .zero))
    }
    
    ///
    /// Set constraint attributes of ``Anchors``
    ///
    /// - Parameter toItem: Represents the `secondItem` property of `NSLayoutConstraint`. It will be UIView, UILayoutGuide, or identifier String.
    /// - Returns: ``Anchors``
    ///
    public func lessThanOrEqualTo<I>(_ toItem: I) -> Self where I: ConstraintableItem {
        to(.lessThanOrEqual, to: .init(item: toItem, attribute: nil, constant: .zero))
    }
    
    ///
    /// Set constraint attributes of ``Anchors``
    ///
    /// - Parameter toItem: Represents the `secondItem` property of `NSLayoutConstraint`. It will be UIView, UILayoutGuide, or identifier String.
    /// - Parameter attribute: Represents the `secondAttribute` property of `NSLayoutConstraint`.
    /// - Returns: ``Anchors``
    ///
    public func equalTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute) -> Self where I: ConstraintableItem {
        to(.equal, to: .init(item: toItem, attribute: attribute, constant: .zero))
    }
    
    ///
    /// Set constraint attributes of ``Anchors``
    ///
    /// - Parameter toItem: Represents the `secondItem` property of `NSLayoutConstraint`. It will be UIView, UILayoutGuide, or identifier String.
    /// - Parameter attribute: Represents the `secondAttribute` property of `NSLayoutConstraint`.
    /// - Returns: ``Anchors``
    ///
    public func greaterThanOrEqualTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute) -> Self where I: ConstraintableItem {
        to(.greaterThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: .zero))
    }
    
    ///
    /// Set constraint attributes of ``Anchors``
    ///
    /// - Parameter toItem: Represents the `secondItem` property of `NSLayoutConstraint`. It will be UIView, UILayoutGuide, or identifier String.
    /// - Parameter attribute: Represents the `secondAttribute` property of `NSLayoutConstraint`.
    /// - Returns: ``Anchors``
    ///
    public func lessThanOrEqualTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute) -> Self where I: ConstraintableItem {
        to(.lessThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: .zero))
    }
    
    ///
    /// Set constraint attributes of ``Anchors``
    ///
    /// - Parameter toItem: Represents the `secondItem` property of `NSLayoutConstraint`. It will be UIView, UILayoutGuide, or identifier String.
    /// - Parameter constant: Represents the `constant` property of `NSLayoutConstraint`.
    /// - Returns: ``Anchors``
    ///
    public func equalTo<I>(_ toItem: I, constant: CGFloat) -> Self where I: ConstraintableItem {
        to(.equal, to: .init(item: toItem, attribute: nil, constant: constant))
    }
    
    ///
    /// Set constraint attributes of ``Anchors``
    ///
    /// - Parameter toItem: Represents the `secondItem` property of `NSLayoutConstraint`. It will be UIView, UILayoutGuide, or identifier String.
    /// - Parameter constant: Represents the `constant` property of `NSLayoutConstraint`.
    /// - Returns: ``Anchors``
    ///
    public func greaterThanOrEqualTo<I>(_ toItem: I, constant: CGFloat) -> Self where I: ConstraintableItem {
        to(.greaterThanOrEqual, to: .init(item: toItem, attribute: nil, constant: constant))
    }
    
    ///
    /// Set constraint attributes of ``Anchors``
    ///
    /// - Parameter toItem: Represents the `secondItem` property of `NSLayoutConstraint`. It will be UIView, UILayoutGuide, or identifier String.
    /// - Parameter constant: Represents the `constant` property of `NSLayoutConstraint`.
    /// - Returns: ``Anchors``
    ///
    public func lessThanOrEqualTo<I>(_ toItem: I, constant: CGFloat) -> Self where I: ConstraintableItem {
        to(.lessThanOrEqual, to: .init(item: toItem, attribute: nil, constant: constant))
    }
    
    ///
    /// Set constraint attributes of ``Anchors``
    ///
    /// - Parameter toItem: Represents the `secondItem` property of `NSLayoutConstraint`. It will be UIView, UILayoutGuide, or identifier String.
    /// - Parameter attribute: Represents the `secondAttribute` property of `NSLayoutConstraint`.
    /// - Parameter constant: Represents the `constant` property of `NSLayoutConstraint`.
    /// - Returns: ``Anchors``
    ///
    public func equalTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Self where I: ConstraintableItem {
        to(.equal, to: .init(item: toItem, attribute: attribute, constant: constant))
    }
    
    ///
    /// Set constraint attributes of ``Anchors``
    ///
    /// - Parameter toItem: Represents the `secondItem` property of `NSLayoutConstraint`. It will be UIView, UILayoutGuide, or identifier String.
    /// - Parameter attribute: Represents the `secondAttribute` property of `NSLayoutConstraint`.
    /// - Parameter constant: Represents the `constant` property of `NSLayoutConstraint`.
    /// - Returns: ``Anchors``
    ///
    public func greaterThanOrEqualTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Self where I: ConstraintableItem {
        to(.greaterThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: constant))
    }
    
    ///
    /// Set constraint attributes of ``Anchors``
    ///
    /// - Parameter toItem: Represents the `secondItem` property of `NSLayoutConstraint`. It will be UIView, UILayoutGuide, or identifier String.
    /// - Parameter attribute: Represents the `secondAttribute` property of `NSLayoutConstraint`.
    /// - Parameter constant: Represents the `constant` property of `NSLayoutConstraint`.
    /// - Returns: ``Anchors``
    ///
    public func lessThanOrEqualTo<I>(_ toItem: I, attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Self where I: ConstraintableItem {
        to(.lessThanOrEqual, to: .init(item: toItem, attribute: attribute, constant: constant))
    }
    
    ///
    /// Set the `constraint` of ``Anchors``
    ///
    /// - Parameter constant: Represents the `constant` property of `NSLayoutConstraint`.
    /// - Returns: ``Anchors``
    ///
    public func setConstant(_ constant: CGFloat) -> Self {
        for i in 0..<items.count {
            items[i].constant = constant
        }
        return self
    }
    
    ///
    /// Set the `multiplier` of ``Anchors``
    ///
    /// - Parameter multiplier: Represents the `multiplier` property of `NSLayoutConstraint`.
    /// - Returns: ``Anchors``
    ///
    public func setMultiplier(_ multiplier: CGFloat) -> Self {
        for i in 0..<items.count {
            items[i].multiplier = multiplier
        }
        return self
    }
}
