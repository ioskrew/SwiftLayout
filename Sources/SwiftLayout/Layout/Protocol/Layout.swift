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
    
    func prepareSuperview(_ superview: UIView?)
    func attachSuperview(_ superview: UIView?)
   
    func prepareConstraints()
    func activeConstraints()
}

public extension Layout {
    
    func active() -> Deactivable {
        return Deactivation(self)
    }
    
    func prepare() {
        prepareSuperview(nil)
        prepareConstraints()
    }
    
    func prepareSuperview(_ superview: UIView?) {
        for layout in sublayouts {
            layout.prepareSuperview(superview)
        }
    }
    
    func prepareConstraints() {
        for layout in sublayouts {
            layout.prepareConstraints()
        }
    }
    
    func activeConstraints() {
        for layout in sublayouts {
            layout.activeConstraints()
        }
    }
}

extension Layout {
    
    func flattening() -> LayoutFlattening? {
        prepare()
        return self as? LayoutFlattening
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

extension Array: Layout where Self.Element == Layout {}
