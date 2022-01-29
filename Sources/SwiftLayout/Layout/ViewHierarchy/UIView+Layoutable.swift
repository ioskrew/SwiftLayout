//
//  UIView+Layoutable.swift
//  
//
//  Created by maylee on 2022/01/29.
//

import Foundation
import UIKit

extension UIView: Layoutable {
    public func moveToSuperlayoutable(_ layoutable: Layoutable) -> Layoutable {
        guard let view = layoutable as? UIView else { return layoutable }
        view.addSubview(self)
        return layoutable
    }
}

internal extension Layoutable {
    var view: UIView? {
        self as? UIView
    }
}

public extension Layoutable where Self: UIView {
    
    @discardableResult
    func callAsFunction(@LayoutBuilder _ content: () -> Layoutable) -> Layoutable {
        content().moveToSuperlayoutable(self)
    }
    
}
