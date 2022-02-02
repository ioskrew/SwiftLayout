//
//  NSLayoutConstraint+Layout.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

extension Layout {
    public func constraint<Constraintable>(@ConstraintBuilder _ constraint: () -> Constraintable) -> LayoutConstraint<Self, Constraintable> where Constraintable: Constraint {
        .init(layout: self, constraint: constraint())
    }
}

