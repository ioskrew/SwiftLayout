import Foundation
import UIKit

extension Anchors {
    @AnchorsBuilder
    ///
    /// leading and trailing constraint to item or superview(.layoutGuide)
    ///
    public static func horizontal<I: ConstraintableItem>(_ item: I, offset: CGFloat = .zero) -> SwiftLayout.Constraint {
        Anchors(.leading).equalTo(item, constant: offset)
        Anchors(.trailing).equalTo(item, constant: -offset)
    }
    
    @AnchorsBuilder
    public static func vertical<I: ConstraintableItem>(_ item: I, offset: CGFloat = .zero) -> SwiftLayout.Constraint {
        Anchors(.top).equalTo(item, constant: offset)
        Anchors(.bottom).equalTo(item, constant: -offset)
    }
    
    @AnchorsBuilder
    public static func allSides<I: ConstraintableItem>(_ item: I, offset: CGFloat = .zero) -> SwiftLayout.Constraint {
        horizontal(item, offset: offset)
        vertical(item, offset: offset)
    }
}
