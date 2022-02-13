//
//  Optional+Layout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

extension Optional: Layout where Wrapped: Layout {
}

extension Optional: _Layout where Wrapped: _Layout {
    
    func prepareSuperview(_ superview: UIView?) {
        self?.prepareSuperview(superview)
    }
    
    func attachSuperview() {
        self?.attachSuperview()
    }
    
    func prepareConstraints() {
        self?.prepareConstraints()
    }
    
    func activeConstraints() {
        self?.activeConstraints()
    }
    
}
