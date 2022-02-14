//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

public protocol Layout: CustomDebugStringConvertible {
    
    var sublayouts: [Layout] { get }
    
    var layoutViews: [ViewInformation] { get }
    var layoutConstraints: [NSLayoutConstraint] { get }
    
    func prepareSuperview(_ superview: UIView?)
    func prepareConstraints(_ identifiers: ViewIdentifiers)
    
    func animation()
    @discardableResult
    func animationDisable() -> Self
}

extension Layout {
    
    func active() -> Deactivable {
        return Deactivation(self)
    }
    
    func prepare() -> Self {
        prepareSuperview(nil)
        prepareConstraints(ViewIdentifiers(views: Set(layoutViews)))
        return self
    }
   
    public func prepareConstraints(_ identifiers: ViewIdentifiers) {
        sublayouts.prepareConstraints(identifiers)
    }
    
    @discardableResult
    public func animationDisable() -> Self {
        sublayouts.animationDisable()
        return self
    }
    
    public func animation() {
        sublayouts.animation()
    }
    
}

extension Layout where Self: Collection, Element == Layout {
    public var sublayouts: [Layout] { map({ layout in layout }) }
}

extension Array: Layout where Self.Element == Layout {
    
    public var layoutViews: [ViewInformation] {
        sublayouts.flatMap(\.layoutViews)
    }
    
    public var layoutConstraints: [NSLayoutConstraint] {
        sublayouts.flatMap(\.layoutConstraints)
    }
    
    public func prepareSuperview(_ superview: UIView?) {
        for layout in sublayouts {
            layout.prepareSuperview(superview)
        }
    }
    
    public func prepareConstraints(_ identifiers: ViewIdentifiers) {
        for layout in sublayouts {
            layout.prepareConstraints(identifiers)
        }
    }
    
    @discardableResult
    public func animationDisable() -> Array<Layout> {
        for layout in sublayouts {
            layout.animationDisable()
        }
        return self
    }
    
    public func animation() {
        for layout in sublayouts {
            layout.animation()
        }
    }
    
}
