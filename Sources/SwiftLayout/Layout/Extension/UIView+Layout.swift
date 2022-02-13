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
    
    public func prepareSuperview(_ superview: UIView?) {}
    public func attachSuperview() {}
    
    public func prepareConstraints() {}
    public func activeConstraints() {}
    
}

extension UIView: Layout {}

