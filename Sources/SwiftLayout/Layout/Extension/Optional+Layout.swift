//
//  Optional+Layout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

extension Optional: Layout where Wrapped: Layout {
    
    public func prepareSuperview(_ superview: UIView?) {
        self?.prepareSuperview(superview)
    }
    
    public func attachSuperview() {
        self?.attachSuperview()
    }
    
    public func detachFromSuperview() {
        self?.detachFromSuperview()
    }
    
    public func prepareConstraints() {
        self?.prepareConstraints()
    }
    
    public func activeConstraints() {
        self?.activeConstraints()
    }
    
    public func deactiveConstraints() {
        self?.deactiveConstraints()
    }
    
}
