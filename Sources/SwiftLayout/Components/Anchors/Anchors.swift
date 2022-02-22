//
//  Anchor.swift
//  
//
//  Created by maylee on 2022/02/08.
//

import Foundation
import UIKit

public final class Anchors: Constraint {
    
    var items: [Constraint] = []
    
    public convenience init(_ attributes: NSLayoutConstraint.Attribute...) {
        let items = attributes.map { Anchors.Constraint(attribute: $0) }
        self.init(items: items)
    }
    
    public convenience init(_ attributes: [NSLayoutConstraint.Attribute]) {
        let items = attributes.map { Anchors.Constraint(attribute: $0) }
        self.init(items: items)
    }
    
    internal init(items: [Anchors.Constraint] = []) {
        self.items = items
    }
    
    public func constraints(item fromItem: NSObject, toItem: NSObject?, viewInfoSet: ViewInformationSet? = nil) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for item in items {
            let from = fromItem
            let attribute = item.attribute
            let relation = item.relation
            let to = item.toItem(toItem, viewInfoSet: viewInfoSet)
            let toAttribute = item.toAttribute(attribute)
            let multiplier = item.multiplier
            let constant = item.constant
            assert(to is UIView || to is UILayoutGuide || to == nil, "to: \(to.debugDescription) is not item")
            constraints.append(NSLayoutConstraint(item: from,
                                                  attribute: attribute,
                                                  relatedBy: relation,
                                                  toItem: to,
                                                  attribute: toAttribute,
                                                  multiplier: multiplier,
                                                  constant: constant))
        }
        return constraints
    }
}

extension Anchors {
    private func to(_ relation: NSLayoutConstraint.Relation, to: ConstraintTarget) -> Self {
        func update(_ updateItem: Constraint) -> Constraint {
            var updateItem = updateItem
            updateItem.relation = relation
            updateItem.toItem = to.item
            updateItem.toAttribute = to.attribute
            updateItem.constant = to.constant
            return updateItem
        }
        
        items = items.map(update)
        return self
    }

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

extension Anchors {
    private struct ConstraintTarget {
        init<I>(item: I?, attribute: NSLayoutConstraint.Attribute?, constant: CGFloat) where I: ConstraintableItem {
            self.item = ItemFromView(item).item
            self.attribute = attribute
            self.constant = constant
        }
        
        init(item: Item = .transparent, attribute: NSLayoutConstraint.Attribute?, constant: CGFloat) {
            self.item = item
            self.attribute = attribute
            self.constant = constant
        }
        
        let item: Item
        let attribute: NSLayoutConstraint.Attribute?
        let constant: CGFloat
    }
    
    struct Constraint: Hashable {
        var attribute: NSLayoutConstraint.Attribute
        var relation: NSLayoutConstraint.Relation = .equal
        var toItem: Item = .transparent
        var toAttribute: NSLayoutConstraint.Attribute?
        
        var constant: CGFloat = 0.0
        var multiplier: CGFloat = 1.0
        
        func toItem(_ toItem: NSObject?, viewInfoSet: ViewInformationSet? = nil) -> NSObject? {
            switch self.toItem {
            case let .object(object):
                return object
            case let .identifier(identifier):
                return viewInfoSet?[identifier] ?? toItem
            case .transparent:
                return toItem
            case .deny:
                switch attribute {
                case .width, .height:
                    return nil
                default:
                    return toItem
                }
            }
        }
        
        func toAttribute(_ attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint.Attribute {
            return toAttribute ?? attribute
        }
    }
    
    enum Item: Hashable {
        case object(NSObject)
        case identifier(String)
        case transparent
        case deny
        
        init(_ item: Any?) {
            if let string = item as? String {
                self = .identifier(string)
            } else if let object = item as? NSObject {
                self = .object(object)
            } else {
                self = .transparent
            }
        }
        
        var object: NSObject? {
            switch self {
            case let .object(object):
                return object
            default:
                return nil
            }
        }
    }
}
