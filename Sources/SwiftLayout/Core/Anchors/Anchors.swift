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
        constraints(item: fromItem, toItem: toItem, viewInfoSet: nil)
    }
    
    func constraints(item fromItem: NSObject, toItem: NSObject?, viewInfoSet: ViewInformationSet?) -> [NSLayoutConstraint] {
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
    
    /// ``Anchors`` for width, height toward toItem: ``ConstraintableItem``
    ///
    ///
    /// - Parameters:
    ///  - toItem: constraint second item, ``ConstraintableItem``
    ///  - length: constant
    ///
    /// - Returns: ``Anchors``
    public static func size<I: ConstraintableItem>(_ toItem: I, offset: CGFloat = .zero) -> Anchors {
        size(toItem, offset: CGSize(width: offset, height: offset))
    }
    
    /// ``Anchors`` for width, height toward self
    ///
    /// - Parameters:
    ///  - length: constant
    ///
    /// - Returns: ``Anchors``
    public static func size(length: CGFloat = .zero) -> Anchors {
        size(.init(width: length, height: length))
    }
    
    /// ``Anchors`` for CGSize toward toItem: ``ConstraintableItem``
    ///
    /// - Parameters:
    ///  - toItem: constraint second item, ``ConstraintableItem``
    ///  - size: constants
    ///
    /// - Returns: ``Anchors``
    public static func size<I: ConstraintableItem>(_ toItem: I, offset: CGSize = .zero) -> Anchors {
        let width = Anchors(.width).equalTo(toItem, constant: offset.width)
        let height = Anchors(.height).equalTo(toItem, constant: offset.height)
        return width.union(height)
    }
    
    /// ``Anchors`` for CGSize toward self
    ///
    /// - Parameters:
    ///  - size: constant
    ///
    /// - Returns: ``Anchors``
    public static func size(_ size: CGSize = .zero) -> Anchors {
        let width = Anchors(.width).equalTo(constant: size.width)
        let height = Anchors(.height).equalTo(constant: size.height)
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
}
