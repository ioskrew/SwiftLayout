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
    
    var layoutViews: [UIView] { get }
    var layoutConstraints: [NSLayoutConstraint] { get }
    
    func prepareSuperview(_ superview: UIView?)
    func attachSuperview(_ superview: UIView?)
   
    func prepareConstraints()
    func activeConstraints()
    
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
        for layout in sublayouts {
            layout.prepareConstraints()
        }
    }
    
    public func activeConstraints() {
        for layout in sublayouts {
            layout.activeConstraints()
        }
    }
}

extension Layout where Self: Collection, Element == Layout {
    public var sublayouts: [Layout] { map({ layout in layout }) }
    
    public func attachSuperview(_ superview: UIView?) {
        for sublayout in sublayouts {
            sublayout.attachSuperview(superview)
        }
    }
}

extension Array: Layout where Self.Element == Layout {
    
    public var layoutViews: [UIView] {
        flatMap(\.layoutViews)
    }
    
    public var layoutConstraints: [NSLayoutConstraint] {
        flatMap(\.layoutConstraints)
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
    
    public func activeConstraints() {
        for layout in sublayouts {
            layout.activeConstraints()
        }
    }
    
}
