//
//  UIView+Anchor.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

extension UIView {
    
    func attribute<Anchor>(_ anchor: Anchor) -> NSLayoutConstraint.Attribute where Anchor: NSLayoutAnchorConstraint {
        .notAnAttribute
    }
    
}
