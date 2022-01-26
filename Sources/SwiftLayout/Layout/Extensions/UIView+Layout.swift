//
//  UIView+Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

extension UIView: Layoutable {
    @discardableResult
    public func callAsFunction(@LayoutBuilder _ layout: () -> Layoutable) -> Layoutable {
        let tree = LayoutTree(self, layout: layout)
        return tree
    }
    
    @discardableResult
    public func layout(@LayoutBuilder _ layout: () -> Layoutable) -> Layoutable {
        let tree = LayoutTree(self, layout: layout)
        tree.active()
        return tree
    }
    
    public func isEqualLayout(_ layoutable: Layoutable) -> Bool {
        guard let view = layoutable as? UIView else { return false }
        return self.isEqual(view)
    }
    
    public func isEqualView(_ layoutable: Layoutable) -> Bool {
        self.isEqual(layoutable)
    }
    
    public func isEqualView(_ view: UIView?) -> Bool {
        self.isEqual(view)
    }
    
    public var layoutIdentifier: String {
        "\(type(of: self))[\(accessibilityIdentifier ?? address)]"
    }
}
