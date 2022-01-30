//
//  Optional+Layoutable.swift
//  
//
//  Created by oozoofrog on 2022/01/29.
//

import Foundation
import UIKit

extension Optional: Layoutable where Wrapped: Layoutable {
    public func active() -> Layoutable {
        self?.active() ?? EmptyLayout()
    }
    
    public func layoutTree(in parent: UIView) -> LayoutTree {
        self?.layoutTree(in: parent) ?? LayoutTree(view: parent)
    }
}
