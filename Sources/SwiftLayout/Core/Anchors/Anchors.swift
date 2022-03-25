//
//  Anchor.swift
//  
//
//  Created by oozoofrog on 2022/02/08.
//

import UIKit

///
/// type of ``AnchorsBuilder`` for auto layout constraint.
///
/// ```swift
/// let parent = UIView()
/// let child = UIView()
/// parent {
///     child.anchors {
///         // constraints(top, bottom, leading, trailing) of child
///         // equal to
///         // constraints(top, bottom, leading, trailing) of parent
///         Anchors.allSides()
///     }
/// }
/// ```
public final class Anchors {
    
    var items: [Constraint] = []
    
    /// initialize and return new Anchors with array of **NSLayoutConstraint.Attribute**
    ///
    /// - Parameter attributes: variadic of **NSLayoutConstraint.Attribute**
    public convenience init(_ attributes: NSLayoutConstraint.Attribute...) {
        let items = attributes.map { Anchors.Constraint(attribute: $0) }
        self.init(items: items)
    }
    
    /// initialize and return new Anchors with array of **NSLayoutConstraint.Attribute**
    ///
    /// - Parameter attributes: array of **NSLayoutConstraint.Attribute**
    public convenience init(_ attributes: [NSLayoutConstraint.Attribute]) {
        let items = attributes.map { Anchors.Constraint(attribute: $0) }
        self.init(items: items)
    }
    
    init(items: [Anchors.Constraint] = []) {
        self.items = items
    }
    
    // MARK: - Cores
    func constraints(item fromItem: NSObject, toItem: NSObject?) -> [NSLayoutConstraint] {
        constraints(item: fromItem, toItem: toItem, viewDic: [:])
    }
    
    func constraints(item fromItem: NSObject, toItem: NSObject?, viewDic: [String: UIView]) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for item in items {
            let from = fromItem
            let attribute = item.attribute
            let relation = item.relation
            let to = item.toItem(toItem, viewDic: viewDic)
            let toAttribute = item.toAttribute(attribute)
            let multiplier = item.multiplier
            let constant = item.constant
            assert(to is UIView || to is UILayoutGuide || to == nil, "to: \(to.debugDescription) is not item")
            let constraint = NSLayoutConstraint(
                item: from,
                attribute: attribute,
                relatedBy: relation,
                toItem: to,
                attribute: toAttribute,
                multiplier: multiplier,
                constant: constant
            )
            constraint.priority = .required
            constraints.append(constraint)
        }
        return constraints
    }
    
    func to(_ relation: NSLayoutConstraint.Relation, to: ConstraintTarget) -> Self {
        func update(_ updateItem: Constraint) -> Constraint {
            let updateItem = updateItem
            updateItem.relation = relation
            updateItem.toItem = to.item
            updateItem.toAttribute = to.attribute
            updateItem.constant = to.constant
            return updateItem
        }
        
        items = items.map(update)
        return self
    }
    
    func union(_ anchors: Anchors) -> Anchors {
        var items = self.items
        items.append(contentsOf: anchors.items)
        return Anchors(items: items)
    }
    
    func formUnion(_ anchors: Anchors) {
        self.items.append(contentsOf: anchors.items)
    }
    
    static func + (lhs: Anchors, rhs: Anchors) -> Anchors {
        lhs.union(rhs)
    }
    
    // MARK: - Relation
    
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
    
    // MARK: - Convenience
    
    ///
    /// ``Anchors`` for leading, trailing
    ///
    /// - Parameters:
    ///  - item: ``ConstraintableItem``
    ///  - offset: CGFloat. leading constant is `offset`, trailing constant is `-offset`
    ///
    /// - Returns: ``Anchors``
    public static func horizontal<I>(_ item: I, offset: CGFloat = .zero) -> Anchors where I: ConstraintableItem {
        if offset == .zero {
            return Anchors(.leading).equalTo(item).union(Anchors(.trailing).equalTo(item))
        } else {
            return Anchors(.leading).equalTo(item, constant: offset).union(Anchors(.trailing).equalTo(item, constant: -1.0 * offset))
        }
    }
    
    /// ``Anchors`` for top, bottom
    ///
    /// - Parameters:
    ///  - item: ``ConstraintableItem``
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`
    ///
    /// - Returns: ``Anchors``
    public static func vertical<I: ConstraintableItem>(_ item: I, offset: CGFloat = .zero) -> Anchors {
        if offset == .zero {
            return Anchors(.top).equalTo(item).union(Anchors(.bottom).equalTo(item))
        } else {
            return Anchors(.top).equalTo(item, constant: offset).union(Anchors(.bottom).equalTo(item, constant: -1.0 * offset))
        }
    }
    
    ///
    /// ``Anchors`` for leading, trailing toward superview
    ///
    /// - Parameters:
    ///  - offset: CGFloat. leading constant is `offset`, trailing constant is `-offset`
    ///
    /// - Returns: ``Anchors``
    public static func horizontal(offset: CGFloat = .zero) -> Anchors {
        if offset == .zero {
            return Anchors(.leading).union(Anchors(.trailing))
        } else {
            return Anchors(.leading).equalTo(constant: offset).union(Anchors(.trailing).equalTo(constant: -1.0 * offset))
        }
    }
    
    /// ``Anchors`` for top, bottom toward superview
    ///
    /// - Parameters:
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`
    ///
    /// - Returns: ``Anchors``
    public static func vertical(offset: CGFloat = .zero) -> Anchors {
        if offset == .zero {
            return Anchors(.top).union(Anchors(.bottom))
        } else {
            return Anchors(.top).equalTo(constant: offset).union(Anchors(.bottom).equalTo(constant: -1.0 * offset))
        }
    }
    
    /// ``Anchors`` for leading, trailing, top, bottom
    ///
    /// - Parameters:
    ///  - item: ``ConstraintableItem``
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`, leading constant is `offset`, trailing constant is `-offset`
    ///
    /// - Returns: ``Anchors``
    public static func allSides<I: ConstraintableItem>(_ item: I, offset: CGFloat = .zero) -> Anchors {
        let horizontal = horizontal(item, offset: offset)
        let vertical = vertical(item, offset: offset)
        return horizontal.union(vertical)
    }
    
    /// ``Anchors`` for leading, trailing, top, bottom toward superview
    ///
    /// - Parameters:
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`, leading constant is `offset`, trailing constant is `-offset`
    ///
    /// - Returns: ``Anchors``
    public static func allSides(offset: CGFloat = .zero) -> Anchors {
        let horizontal = horizontal(offset: offset)
        let vertical = vertical(offset: offset)
        return horizontal.union(vertical)
    }
    
    /// ``Anchors`` for leading, trailing, top toward superview
    ///
    /// - Parameters:
    ///  - item: ``ConstraintableItem``
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`, leading constant is `offset`
    ///
    /// - Returns: ``Anchors``
    public static func cap<I: ConstraintableItem>(_ item: I, offset: CGFloat = .zero) -> Anchors {
        let horizontal = horizontal(item, offset: offset)
        let top = Anchors(.top).equalTo(item, constant: offset)
        return horizontal.union(top)
    }
    
    /// ``Anchors`` for leading, trailing, bottom toward superview
    ///
    /// - Parameters:
    ///  - item: ``ConstraintableItem``
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`, trailing constant is `-offset`
    ///
    /// - Returns: ``Anchors``
    public static func shoe<I: ConstraintableItem>(_ item: I, offset: CGFloat = .zero) -> Anchors {
        let horizontal = horizontal(item, offset: offset)
        let bottom = Anchors(.bottom).equalTo(item, constant: -1.0 * offset)
        return horizontal.union(bottom)
    }
    
    /// ``Anchors`` for leading, trailing, top toward superview
    ///
    /// - Parameters:
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`, leading constant is `offset`
    ///
    /// - Returns: ``Anchors``
    public static func cap(offset: CGFloat = .zero) -> Anchors {
        let horizontal = horizontal(offset: offset)
        let top = Anchors(.top).equalTo(constant: offset)
        return horizontal.union(top)
    }
    
    /// ``Anchors`` for leading, trailing, bottom toward superview
    ///
    /// - Parameters:
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`, trailing constant is `-offset`
    ///
    /// - Returns: ``Anchors``
    public static func shoe(offset: CGFloat = .zero) -> Anchors {
        let horizontal = horizontal(offset: offset)
        let bottom = Anchors(.bottom).equalTo(constant: -1.0 * offset)
        return horizontal.union(bottom)
    }
    
    /// ``Anchors`` for width, height toward self
    ///
    /// - Parameters:
    ///  - length: constant, default value is 0.0
    ///
    /// - Returns: ``Anchors``
    public static func size(length: CGFloat = 0.0) -> Anchors {
        size(width: length, height: length)
    }
    
    /// ``Anchors`` for CGSize toward self
    ///
    /// - Parameters:
    ///  - size: constant
    ///
    /// - Returns: ``Anchors``
    public static func size(_ size: CGSize) -> Anchors {
        self.size(width: size.width, height: size.height)
    }
    
    /// ``Anchors`` for width, height toward self
    ///
    /// - Parameters:
    ///  - width: constant
    ///  - height: constant
    ///
    /// - Returns: ``Anchors``
    public static func size(width: CGFloat, height: CGFloat) -> Anchors {
        let width = Anchors(.width).equalTo(constant: width)
        let height = Anchors(.height).equalTo(constant: height)
        return width.union(height)
    }
    
    /// ``Anchors`` for width, height toward toItem: ``ConstraintableItem``
    ///
    ///
    /// - Parameters:
    ///  - toItem: constraint second item, ``ConstraintableItem``
    ///
    /// - Returns: ``Anchors``
    public static func size<I: ConstraintableItem>(_ toItem: I) -> Anchors {
        size(toItem, offset: .zero)
    }
    
    /// ``Anchors`` for CGSize toward toItem: ``ConstraintableItem``
    ///
    /// - Parameters:
    ///  - toItem: constraint second item, ``ConstraintableItem``
    ///  - size: constants
    ///
    /// - Returns: ``Anchors``
    public static func size<I: ConstraintableItem>(_ toItem: I, offset: CGSize) -> Anchors {
        let width = Anchors(.width).equalTo(toItem, constant: offset.width)
        let height = Anchors(.height).equalTo(toItem, constant: offset.height)
        return width.union(height)
    }
    
    /// ``Anchors`` for center to superview
    /// - Parameters:
    ///   - offsetX: **CGFloat** type. == superview.center.x += offsetX
    ///   - offsetY: **CGFloat** type. == superview.center.y += offsetY
    /// - Returns: ``Anchors``
    public static func center(offsetX: CGFloat = .zero, offsetY: CGFloat = .zero) -> Anchors {
        let x = Anchors(.centerX).equalTo(constant: offsetX)
        let y = Anchors(.centerY).equalTo(constant: offsetY)
        return x.union(y)
    }
    
    /// ``Anchors`` for center to item
    /// - Parameters:
    ///   - toItem: ``ConstraintableItem`` type,  second item for constraint
    ///   - offsetX: **CGFloat** type. == item.center.x += offsetX
    ///   - offsetY: **CGFloat** type. == item.center.y += offsetY
    /// - Returns: ``Anchors``
    public static func center<I: ConstraintableItem>(_ toItem:I, offsetX: CGFloat = .zero, offsetY: CGFloat = .zero) -> Anchors {
        let x = Anchors(.centerX).equalTo(toItem, constant: offsetX)
        let y = Anchors(.centerY).equalTo(toItem, constant: offsetY)
        return x.union(y)
    }
    
    // MARK: - Models
    struct ConstraintTarget {
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
    
    final class Constraint: Hashable, CustomStringConvertible {
        static func == (lhs: Anchors.Constraint, rhs: Anchors.Constraint) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
        
        internal init(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation = .equal, toItem: Anchors.Item = .transparent, toAttribute: NSLayoutConstraint.Attribute? = nil, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0) {
            self.attribute = attribute
            self.relation = relation
            self.toItem = toItem
            self.toAttribute = toAttribute
            self.constant = constant
            self.multiplier = multiplier
        }
        
        var attribute: NSLayoutConstraint.Attribute
        var relation: NSLayoutConstraint.Relation = .equal
        var toItem: Item = .transparent
        var toAttribute: NSLayoutConstraint.Attribute?
        
        var constant: CGFloat = 0.0
        var multiplier: CGFloat = 1.0
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(attribute)
            hasher.combine(relation)
            hasher.combine(toItem)
            hasher.combine(toAttribute)
            hasher.combine(constant)
            hasher.combine(multiplier)
        }
        
        func toItem(_ toItem: NSObject?, viewDic: [String: UIView]) -> NSObject? {
            switch self.toItem {
            case let .object(object):
                return object
            case let .identifier(identifier):
                return viewDic[identifier] ?? toItem
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
        
        var description: String {
            var elements = attributeDescription()
            elements.append(contentsOf: valuesDescription())
            return elements.joined(separator: " ")
        }
        
        func attributeDescription() -> [String] {
            var elements = Array<String>()
            elements.append(".".appending(attribute.description))
            elements.append(relation.shortDescription)
            if let itemDescription = toItem.shortDescription {
                if let toAttribute = toAttribute {
                    elements.append(itemDescription.appending(".").appending(toAttribute.description))
                } else {
                    elements.append(itemDescription.appending(".").appending(attribute.description))
                }
            } else if attribute != .height && attribute != .width {
                if let toAttribute = toAttribute {
                    elements.append("superview.".appending(toAttribute.description))
                } else {
                    elements.append("superview.".appending(attribute.description))
                }
            }
            return elements
        }
        
        func valuesDescription() -> [String] {
            var elements = Array<String>()
            if multiplier != 1.0 {
                elements.append("x ".appending(multiplier.description))
            }

            if constant < 0.0 {
                elements.append("- ".appending(abs(constant).description))
            } else if constant > 0.0 {
                elements.append("+ ".appending(constant.description))
            }
            return elements
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
        
        var shortDescription: String? {
            switch self {
            case .object(let object):
                if let view = object as? UIView {
                    return view.tagDescription
                } else if let guide = object as? UILayoutGuide {
                    return guide.propertyDescription
                } else {
                    return "unknown"
                }
            case .identifier(let string):
                return string
            case .transparent:
                return "superview"
            case .deny:
                return nil
            }
        }
    }
}
