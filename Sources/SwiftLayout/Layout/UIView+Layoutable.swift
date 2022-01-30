//
//  UIView+Layoutable.swift
//  
//
//  Created by maylee on 2022/01/29.
//

import Foundation
import UIKit

extension UIView: Layoutable {
    public func active() -> Layoutable {
        self
    }
    
    public func layoutTree(in parent: UIView) -> LayoutTree {
        LayoutTree(view: parent, subtree: [LayoutTree(view: self)])
    }
}

public extension Layoutable where Self: UIView {
    
    @discardableResult
    func callAsFunction(@LayoutBuilder _ content: () -> Layoutable) -> Layoutable {
        content().layoutTree(in: self)
    }
    
}
