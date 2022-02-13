//
//  Optional+Layout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

extension Optional: Layout where Wrapped: Layout {
    
    public var sublayouts: [Layout] { self?.sublayouts ?? [] }
    
    public func prepareSuperview(_ superview: UIView?) {
        self?.prepareSuperview(superview)
    }
    
    public func attachSuperview(_ superview: UIView?) {
        self?.attachSuperview(superview)
    }
    
    public func prepareConstraints() {
        self?.prepareConstraints()
    }
    
    public func activeConstraints() {
        self?.activeConstraints()
    }
    
}
