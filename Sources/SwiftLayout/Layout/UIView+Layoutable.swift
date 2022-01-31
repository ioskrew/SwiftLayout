//
//  UIView+Layoutable.swift
//  
//
//  Created by maylee on 2022/01/29.
//

import Foundation
import UIKit

extension UIView: Layout {
 
    public func layoutTree(in parent: UIView) -> LayoutTree {
        LayoutTree(view: parent, subtree: [LayoutTree(view: self)])
    }
    
    public var equation: AnyHashable {
        AnyHashable(self)
    }
}

public extension Layout where Self: UIView {
    
    @discardableResult
    func callAsFunction<Sub>(@LayoutBuilder _ content: () -> Sub) -> SuperSubLayout<Self, Sub> where Sub: Layout {
        SuperSubLayout<Self, Sub>(superview: self, subLayout: content())
    }
    
}
