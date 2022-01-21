//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

extension UIView: LayoutElement {
    var view: UIView { self }
    public func active() -> LayoutTree {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

public extension UIView {
    
    @discardableResult
    func callAsFunction(@LayoutBuilder _ content: () -> LayoutTree) -> LayoutTree {
        self
    }

    @discardableResult
    func layout(@LayoutBuilder _ content: () -> LayoutTree) -> LayoutTree {
        self
    }
    
}
