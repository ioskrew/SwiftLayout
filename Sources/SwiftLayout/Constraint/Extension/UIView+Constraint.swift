//
//  UIView+Layout.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

extension Layout where Self: UIView {
    
    public func constraint(@ConstraintBuilder _ content: () -> [ConstraintBinding]) -> ConstraintLayout {
        .init(view: self, constraint: content())
    }
    
}

extension UIView: ConstraintCreating {}
