//
//  UIView+Layout.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

extension Layout where Self: UIView {
    
    public func anchors<C>(@AnchorsBuilder _ anchors: () -> C) -> AnchorsLayout<C> where C: Constraint {
        .init(view: self, constraint: anchors())
    }
    
}

