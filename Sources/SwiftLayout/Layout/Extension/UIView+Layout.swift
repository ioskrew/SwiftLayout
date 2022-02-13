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
    
}

extension _Layout where Self: UIView {
    
    func prepareSuperview(_ superview: UIView?) {}
    func attachSuperview() {}
    
    func prepareConstraints() {}
    func activeConstraints() {}

}

extension UIView: Layout {}
extension UIView: _Layout {}
