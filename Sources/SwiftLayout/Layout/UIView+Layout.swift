//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

extension UIView: LayoutTree {
    
    @discardableResult
    func callAsFunction(@LayoutBuilder _ content: () -> LayoutTree) -> LayoutTree {
        layout(content)
    }

    @discardableResult
    func layout(@LayoutBuilder _ content: () -> LayoutTree) -> LayoutTree {
        _LayoutTree(element: _LayoutElement(view: self), content: content) }
    
    @discardableResult
    public func active() -> LayoutTree {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
