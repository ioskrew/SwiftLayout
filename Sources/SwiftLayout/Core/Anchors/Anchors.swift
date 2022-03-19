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
}
