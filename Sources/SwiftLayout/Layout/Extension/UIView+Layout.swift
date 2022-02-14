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
    
    public func identifying(_ identifier: String) -> ViewLayout {
        self.accessibilityIdentifier = identifier
       return ViewLayout(view: self, sublayouts: [], identifier: identifier)
    }
}

extension UIView: Layout {
    public var layoutViews: [ViewInformation] {
        [.init(superview: nil, view: self, identifier: accessibilityIdentifier)]
    }
    
    public var layoutConstraints: [NSLayoutConstraint] {
        []
    }
    
    public var sublayouts: [Layout] { [self] }
    
    public func animation() {}
}

