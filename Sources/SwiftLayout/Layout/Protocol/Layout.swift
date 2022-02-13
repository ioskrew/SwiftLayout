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
    
    var layoutViews: [ViewPair] { get }
    var layoutConstraints: [NSLayoutConstraint] { get }
    
    func prepareSuperview(_ superview: UIView?)
    func prepareConstraints()
    
    func animation()
}

extension Layout {
    
    func active() -> Deactivable {
        return Deactivation(self)
    }
    
    func prepare() -> Self {
        prepareSuperview(nil)
        prepareConstraints()
        return self
    }
   
    public func prepareConstraints() {
        sublayouts.prepareConstraints()
    }
    
    public func animation() {
        sublayouts.animation()
    }
}

extension Layout where Self: Collection, Element == Layout {
    public var sublayouts: [Layout] { map({ layout in layout }) }
}

extension Array: Layout where Self.Element == Layout {
    
    public var layoutViews: [ViewPair] {
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
    
    public func prepareConstraints() {
        for layout in sublayouts {
            layout.prepareConstraints()
        }
    }
    
    public func animation() {
        for layout in sublayouts {
            layout.animation()
        }
    }
    
}
