//
//  UIView+Layout.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

extension Layout where Self: UIView {
    
    public func constraint<C>(@ConstraintBuilder _ content: () -> C) -> ConstraintLayout<Self, C> where C: Constraint {
        .init(view: self, constraint: content())
    }
    
}
