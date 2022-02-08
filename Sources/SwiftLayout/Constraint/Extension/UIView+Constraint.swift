//
//  UIView+Layout.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

extension Layout where Self: UIView {
    
    public func anchors(@ConstraintBuilder _ content: () -> [Anchor]) -> ConstraintLayout {
        .init(view: self, constraint: content())
    }
    
}

