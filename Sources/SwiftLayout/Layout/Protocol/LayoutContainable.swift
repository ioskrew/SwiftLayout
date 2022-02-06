//
//  LayoutContainable.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol LayoutContainable: Layout {
    var layouts: [Layout] { get }
}

public extension LayoutContainable {
    func attachSuperview(_ superview: UIView?) {
        for layout in layouts {
            layout.attachSuperview(superview)
        }
    }
    func detachFromSuperview(_ superview: UIView?) {
        for layout in layouts {
            layout.detachFromSuperview(superview)
        }
    }
    func activeConstraints() {
        for layout in layouts {
            layout.activeConstraints()
        }
    }
    func deactiveConstraints() {
        for layout in layouts {
            layout.deactiveConstraints()
        }
    }
    
    public var hashable: AnyHashable {
        AnyHashable(layouts.map(\.hashable))
    }
}

extension Layout where Self: LayoutContainable, Self: Collection, Element == Layout {
    public var layouts: [Layout] {
        map({ $0 as Layout })
    }
}

extension Array: LayoutContainable where Self.Element == Layout {}
