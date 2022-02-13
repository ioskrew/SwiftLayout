//
//  UIView+Layout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

extension Layout where Self: UIView {
    
    public func callAsFunction(@LayoutBuilder _ build: () -> [Layout]) -> ViewLayout {
        ViewLayout(view: self, sublayouts: build())
    }
    
    public func prepareSuperview(_ superview: UIView?) {}
    public func prepareConstraints() {}
    
    public func animationDisable() -> Self {
        layer.removeAllAnimations()
        return self
    }
    
}

extension UIView: Layout {
    public var layoutViews: [ViewPair] {
        [.init(superview: nil, view: self)]
    }
    
    public var layoutConstraints: [NSLayoutConstraint] {
        []
    }
    
    public var sublayouts: [Layout] { [self] }
    
    public func animation() {}
}

