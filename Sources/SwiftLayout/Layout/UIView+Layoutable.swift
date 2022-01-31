//
//  UIView+Layoutable.swift
//  
//
//  Created by maylee on 2022/01/29.
//

import Foundation
import UIKit

extension UIView: Layout {
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

public extension Layout where Self: UIView {
    
    @discardableResult
    func callAsFunction(@LayoutBuilder _ content: () -> Layout) -> Layout {
        content().layoutTree(in: self)
    }
    
}
