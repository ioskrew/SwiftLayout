//
//  UIView+Constraint.swift
//  
//
//  Created by oozoofrog on 2022/01/25.
//

import Foundation
import UIKit

public extension UIView {
    
    var top: SwiftLayout.Constraint {
        SwiftLayout.Constraint(rule: .default, element: .init(item: .view(self), attribute: .top))
    }
    
}
