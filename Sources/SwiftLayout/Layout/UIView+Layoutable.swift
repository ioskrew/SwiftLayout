//
//  UIView+Layoutable.swift
//  
//
//  Created by maylee on 2022/01/29.
//

import Foundation
import UIKit

extension UIView: Layoutable {
    public func active() -> AnyLayoutable {
        AnyLayoutable(self)
    }
    
    public func layoutTree(in parent: UIView) -> LayoutTree {
        LayoutTree(view: self, subtree: [])
    }
    
    public var equation: AnyHashable {
        AnyHashable(self)
    }
}

public extension Layoutable where Self: UIView {
    
    @discardableResult
    func callAsFunction(@LayoutBuilder _ content: () -> Layoutable) -> Layoutable {
        content().layoutTree(in: self)
    }
    
}
