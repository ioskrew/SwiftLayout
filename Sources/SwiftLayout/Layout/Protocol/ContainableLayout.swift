//
//  ContainableLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol ContainableLayout: Layout {
    var layouts: [Layout] { get }
}

public extension ContainableLayout {
    
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

extension Layout where Self: ContainableLayout, Self: Collection, Element == Layout {
    public var layouts: [Layout] {
        map({ $0 as Layout })
    }
}

extension Array: ContainableLayout where Self.Element == Layout {}
