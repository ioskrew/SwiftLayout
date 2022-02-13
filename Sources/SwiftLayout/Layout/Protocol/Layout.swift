//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

public protocol Layout: CustomDebugStringConvertible {
    
    var layouts: [Layout] { get }
    
    func prepareSuperview(_ superview: UIView?)
    func attachSuperview()
   
    func prepareConstraints()
    func activeConstraints()
}

public extension Layout {
    
    var layouts: [Layout] { [] }
    
    func active() -> Deactivable {
        return Deactivation(self)
    }
    
    func prepare() {
        prepareSuperview(nil)
        prepareConstraints()
    }
    
    func prepareSuperview(_ superview: UIView?) {
        for layout in layouts {
            layout.prepareSuperview(superview)
        }
    }
    
    func attachSuperview() {
        for layout in layouts {
            layout.attachSuperview()
        }
    }
    
    func prepareConstraints() {
        for layout in layouts {
            layout.prepareConstraints()
        }
    }
    
    func activeConstraints() {
        for layout in layouts {
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
    public var layouts: [Layout] { self.map({ $0 }) }
}

extension Array: Layout where Self.Element == Layout {}
extension Set: Layout where Self.Element: Layout {}
