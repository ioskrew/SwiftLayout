import Foundation
import UIKit

extension Anchors {
    
    private func union(_ anchors: Anchors) -> Anchors {
        items.append(contentsOf: anchors.items)
        return self
    }
    
    ///
    /// ``Anchors`` for leading, trailing
    ///
    /// - Parameters:
    ///  - item: ``ConstraintableItem``
    ///  - offset: CGFloat. leading constant is `offset`, trailing constant is `-offset`
    ///
    /// - Returns: ``Constraint``
    public static func horizontal<I: ConstraintableItem>(_ item: I, offset: CGFloat = .zero) -> Anchors {
        let leading = Anchors(.leading).equalTo(item, constant: offset)
        let trailing = Anchors(.trailing).equalTo(item, constant: -offset)
        return leading.union(trailing)
    }
    
    /// ``Anchors`` for top, bottom
    ///
    /// - Parameters:
    ///  - item: ``ConstraintableItem``
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`
    ///
    /// - Returns: ``Constraint``
    public static func vertical<I: ConstraintableItem>(_ item: I, offset: CGFloat = .zero) -> Anchors {
        let top = Anchors(.top).equalTo(item, constant: offset)
        let bottom = Anchors(.bottom).equalTo(item, constant: -offset)
        return top.union(bottom)
    }
    
    ///
    /// ``Anchors`` for leading, trailing toward superview
    ///
    /// - Parameters:
    ///  - offset: CGFloat. leading constant is `offset`, trailing constant is `-offset`
    ///
    /// - Returns: ``Constraint``
    public static func horizontal(offset: CGFloat = .zero) -> Anchors {
        let leading = Anchors(.leading).equalTo(constant: offset)
        let trailing = Anchors(.trailing).equalTo(constant: -offset)
        return leading.union(trailing)
    }
    
    /// ``Anchors`` for top, bottom toward superview
    ///
    /// - Parameters:
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`
    ///
    /// - Returns: ``Constraint``
    public static func vertical(offset: CGFloat = .zero) -> Anchors {
        let top = Anchors(.top).equalTo(constant: offset)
        let bottom = Anchors(.bottom).equalTo(constant: -offset)
        return top.union(bottom)
    }
    
    /// ``Anchors`` for leading, trailing, top, bottom
    ///
    /// - Parameters:
    ///  - item: ``ConstraintableItem``
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`, leading constant is `offset`, trailing constant is `-offset`
    ///
    /// - Returns: ``Constraint``
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
    /// - Returns: ``Constraint``
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
    /// - Returns: ``Constraint``
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
    /// - Returns: ``Constraint``
    public static func shoe<I: ConstraintableItem>(_ item: I, offset: CGFloat = .zero) -> Anchors {
        let horizontal = horizontal(item, offset: offset)
        let bottom = Anchors(.bottom).equalTo(item, constant: -offset)
        return horizontal.union(bottom)
    }
    
    /// ``Anchors`` for leading, trailing, top toward superview
    ///
    /// - Parameters:
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`, leading constant is `offset`
    ///
    /// - Returns: ``Constraint``
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
    /// - Returns: ``Constraint``
    public static func shoe(offset: CGFloat = .zero) -> Anchors {
        let horizontal = horizontal(offset: offset)
        let bottom = Anchors(.bottom).equalTo(constant: -offset)
        return horizontal.union(bottom)
    }
    
    /// ``Anchors`` for width, height toward toItem: ``ConstraintableItem``
    ///
    ///
    /// - Parameters:
    ///  - toItem: constraint second item, ``ConstraintableItem``
    ///  - length: constant
    ///
    /// - Returns: ``Constraint``
    public static func size<I: ConstraintableItem>(_ toItem: I, length: CGFloat = .zero) -> Anchors {
        size(toItem, size: .init(width: length, height: length))
    }
    
    /// ``Anchors`` for width, height toward self
    ///
    /// - Parameters:
    ///  - length: constant
    ///
    /// - Returns: ``Constraint``
    public static func size(length: CGFloat = .zero) -> Anchors {
        size(.init(width: length, height: length))
    }
    
    /// ``Anchors`` for CGSize toward toItem: ``ConstraintableItem``
    ///
    /// - Parameters:
    ///  - toItem: constraint second item, ``ConstraintableItem``
    ///  - size: constants
    ///
    /// - Returns: ``Constraint``
    public static func size<I: ConstraintableItem>(_ toItem: I, size: CGSize = .zero) -> Anchors {
        let width = Anchors(.width).equalTo(toItem, constant: size.width)
        let height = Anchors(.height).equalTo(toItem, constant: size.height)
        return width.union(height)
    }
    
    /// ``Anchors`` for CGSize toward self
    ///
    /// - Parameters:
    ///  - size: constant
    ///
    /// - Returns: ``Constraint``
    public static func size(_ size: CGSize = .zero) -> Anchors {
        let width = Anchors(.width).equalTo(constant: size.width)
        let height = Anchors(.height).equalTo(constant: size.height)
        return width.union(height)
    }
}
