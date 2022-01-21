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
    func callAsFunction(@LayoutBuilder _ layout: () -> Layoutable) -> Layoutable {
        LayoutTree(view: .view(self), branches: [layout()])
    }
    
    public func isEqualLayout(_ layoutable: Layoutable) -> Bool {
        guard let view = layoutable as? UIView else { return false }
        return self.isEqual(view)
    }
    
    public var layoutIdentifier: String {
        "\(accessibilityIdentifier ?? address)(\(type(of: self)))"
    }
}
