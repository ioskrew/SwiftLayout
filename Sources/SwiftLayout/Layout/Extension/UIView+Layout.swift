//
//  UIView+Layout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

extension Layout where Self: UIView {
    
    public func callAsFunction<L>(@LayoutBuilder _ build: () -> L) -> ViewLayout<L> where L: Layout {
        ViewLayout(view: self, layoutable: build())
    }
    
    public func attachSuperview(_ superview: UIView?) {
        superview?.addSubview(self)
    }
    
    public func detachFromSuperview(_ superview: UIView?) {
        guard self.superview == superview else { return }
        removeFromSuperview()
    }
    
    public func activeConstraints() {}
    public func deactiveConstraints() {}
    
    public var hashable: AnyHashable {
        AnyHashable(self)
    }
}

extension UIView: Layout {}

