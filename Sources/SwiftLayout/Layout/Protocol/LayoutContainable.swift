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

extension LayoutContainable {
    public func attachSuperview(_ superview: UIView?) {
        for layout in layouts {
            layout.attachSuperview(superview)
        }
    }
    public func detachFromSuperview(_ superview: UIView?) {
        for layout in layouts {
            layout.detachFromSuperview(superview)
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
