//
//  Optional+Layoutable.swift
//  
//
//  Created by oozoofrog on 2022/01/29.
//

import Foundation
import UIKit

extension Optional: Layout where Wrapped: Layout {
    public func active() -> AnyLayoutable {
        self?.active() ?? AnyLayoutable(nil)
    }
    
    public func layoutTree(in parent: UIView) -> LayoutTree {
        self?.layoutTree(in: parent) ?? LayoutTree(view: parent)
    }
    
    public var equation: AnyHashable {
        AnyHashable(self?.equation)
    }
}
