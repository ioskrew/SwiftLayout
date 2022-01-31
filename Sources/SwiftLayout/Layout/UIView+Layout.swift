//
//  UIView+Layoutable.swift
//  
//
//  Created by maylee on 2022/01/29.
//

import Foundation
import UIKit

extension UIView: AttachableLayout {
    
    public func active() -> AnyLayout {
        AnyLayout(self)
    }
    
    public func deactive() {
        removeFromSuperview()
    }
    
    public func attachLayout(_ layout: AttachableLayout) {
        layout.addSubview(self)
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
