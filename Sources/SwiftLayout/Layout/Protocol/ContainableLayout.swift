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

extension ContainableLayout where Self: _Layout {
    
    var _layouts: [_Layout] { layouts as? [_Layout] ?? [] }
    
    func prepareSuperview(_ superview: UIView?) {
        for layout in _layouts {
            layout.prepareSuperview(superview)
        }
    }
    
    func attachSuperview() {
        for layout in _layouts {
            layout.attachSuperview()
        }
    }
    
    func prepareConstraints() {
        for layout in _layouts {
            layout.prepareConstraints()
        }
    }
    
    func activeConstraints() {
        for layout in _layouts {
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
