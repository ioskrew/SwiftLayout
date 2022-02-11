//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

public protocol Layout: CustomDebugStringConvertible {
    func attachSuperview(_ superview: UIView?)
    func attachSuperview()
    func detachFromSuperview(_ superview: UIView?)
    func detachFromSuperview()
   
    func activeConstraints()
    func deactiveConstraints()
    
    var hashable: AnyHashable { get }
}

extension Layout {
    
    public func active() -> Deactivable {
        attachSuperview()
        return Deactivation(self)
    }
    
    public func attachSuperview() {
        attachSuperview(nil)
        activeConstraints()
    }
    public func detachFromSuperview() {
        deactiveConstraints()
        detachFromSuperview(nil)
    }
}

extension Array: Layout where Self.Element == Layout {}
