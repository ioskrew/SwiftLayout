import Foundation
import UIKit

extension Anchors {
    ///
    /// ``Anchors`` for leading, trailing
    ///
    /// - Parameters:
    ///  - item: ``ConstraintableItem``
    ///  - offset: CGFloat. leading constant is `offset`, trailing constant is `-offset`
    ///
    /// - Returns: ``Constraint``
    @AnchorsBuilder
    public static func horizontal<I: ConstraintableItem>(_ item: I, offset: CGFloat = .zero) -> SwiftLayout.Constraint {
        Anchors(.leading).equalTo(item, constant: offset)
        Anchors(.trailing).equalTo(item, constant: -offset)
    }
    
    /// ``Anchors`` for top, bottom
    ///
    /// - Parameters:
    ///  - item: ``ConstraintableItem``
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`
    ///
    /// - Returns: ``Constraint``
    @AnchorsBuilder
    public static func vertical<I: ConstraintableItem>(_ item: I, offset: CGFloat = .zero) -> SwiftLayout.Constraint {
        Anchors(.top).equalTo(item, constant: offset)
        Anchors(.bottom).equalTo(item, constant: -offset)
    }
    
    ///
    /// ``Anchors`` for leading, trailing toward superview
    ///
    /// - Parameters:
    ///  - offset: CGFloat. leading constant is `offset`, trailing constant is `-offset`
    ///
    /// - Returns: ``Constraint``
    @AnchorsBuilder
    public static func horizontal(offset: CGFloat = .zero) -> SwiftLayout.Constraint {
        Anchors(.leading).equalTo(constant: offset)
        Anchors(.trailing).equalTo(constant: -offset)
    }
    
    /// ``Anchors`` for top, bottom toward superview
    ///
    /// - Parameters:
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`
    ///
    /// - Returns: ``Constraint``
    @AnchorsBuilder
    public static func vertical(offset: CGFloat = .zero) -> SwiftLayout.Constraint {
        Anchors(.top).equalTo(constant: offset)
        Anchors(.bottom).equalTo(constant: -offset)
    }
    
    /// ``Anchors`` for leading, trailing, top, bottom
    ///
    /// - Parameters:
    ///  - item: ``ConstraintableItem``
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`, leading constant is `offset`, trailing constant is `-offset`
    ///
    /// - Returns: ``Constraint``
    @AnchorsBuilder
    public static func allSides<I: ConstraintableItem>(_ item: I, offset: CGFloat = .zero) -> SwiftLayout.Constraint {
        horizontal(item, offset: offset)
        vertical(item, offset: offset)
    }
    
    /// ``Anchors`` for leading, trailing, top, bottom toward superview
    ///
    /// - Parameters:
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`, leading constant is `offset`, trailing constant is `-offset`
    ///
    /// - Returns: ``Constraint``
    @AnchorsBuilder
    public static func allSides(offset: CGFloat = .zero) -> SwiftLayout.Constraint {
        horizontal(offset: offset)
        vertical(offset: offset)
    }
    
    /// ``Anchors`` for leading, trailing, top toward superview
    ///
    /// - Parameters:
    ///  - item: ``ConstraintableItem``
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`, leading constant is `offset`
    ///
    /// - Returns: ``Constraint``
    @AnchorsBuilder
    public static func cap<I: ConstraintableItem>(_ item: I, offset: CGFloat = .zero) -> SwiftLayout.Constraint {
        horizontal(item, offset: offset)
        Anchors(.top).equalTo(item, constant: offset)
    }
    
    /// ``Anchors`` for leading, trailing, bottom toward superview
    ///
    /// - Parameters:
    ///  - item: ``ConstraintableItem``
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`, trailing constant is `-offset`
    ///
    /// - Returns: ``Constraint``
    @AnchorsBuilder
    public static func shoe<I: ConstraintableItem>(_ item: I, offset: CGFloat = .zero) -> SwiftLayout.Constraint {
        horizontal(item, offset: offset)
        Anchors(.bottom).equalTo(item, constant: -offset)
    }
    
    /// ``Anchors`` for leading, trailing, top toward superview
    ///
    /// - Parameters:
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`, leading constant is `offset`
    ///
    /// - Returns: ``Constraint``
    @AnchorsBuilder
    public static func cap(offset: CGFloat = .zero) -> SwiftLayout.Constraint {
        horizontal(offset: offset)
        Anchors(.top).equalTo(constant: offset)
    }
    
    /// ``Anchors`` for leading, trailing, bottom toward superview
    ///
    /// - Parameters:
    ///  - offset: CGFloat. top constant is `offset`, bottom constant is `-offset`, trailing constant is `-offset`
    ///
    /// - Returns: ``Constraint``
    @AnchorsBuilder
    public static func shoe(offset: CGFloat = .zero) -> SwiftLayout.Constraint {
        horizontal(offset: offset)
        Anchors(.bottom).equalTo(constant: -offset)
    }
}
