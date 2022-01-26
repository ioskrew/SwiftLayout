//
//  UIView+Constraint.swift
//  
//
//  Created by oozoofrog on 2022/01/25.
//

import Foundation
import UIKit

extension UIView: LayoutVisualize {
    func element(_ attribute: NSLayoutConstraint.Attribute) -> SwiftLayout.Element {
        SwiftLayout.Element(item: .view(self), attribute: attribute)
    }
}
