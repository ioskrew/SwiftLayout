//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

public protocol Layout {
    func attachSuperview(_ superview: UIView?)
    func attachSuperview()
    func detachFromSuperview(_ superview: UIView?)
    func detachFromSuperview()
    
    var hashable: AnyHashable { get }
}

extension Layout {
    
    public func active() -> AnyDeactivatable {
        attachSuperview()
        return AnyDeactivatable(self)
    }
    
    public func attachSuperview() {
        attachSuperview(nil)
    }
    public func detachFromSuperview() {
        detachFromSuperview(nil)
    }
}

extension Array: Layout where Self.Element == Layout {}
