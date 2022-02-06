//
//  OptionalLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

extension Optional: Layout where Wrapped: Layout {
    
    public func attachSuperview(_ superview: UIView?) {
        self?.attachSuperview(superview)
    }
    
    public func detachFromSuperview(_ superview: UIView?) {
        self?.detachFromSuperview(superview)
    }
    
    public func activeConstraints() {
        self?.activeConstraints()
    }
    
    public func deactiveConstraints() {
        self?.deactiveConstraints()
    }
    
    public var hashable: AnyHashable {
        AnyHashable(self?.hashable)
    }
}
