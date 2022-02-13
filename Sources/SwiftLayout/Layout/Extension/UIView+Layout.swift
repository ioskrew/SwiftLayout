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
    public func attachSuperview(_ superview: UIView?) {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addSubview(self)
    }
    
    public func prepareConstraints() {}
    public func activeConstraints() {}
    
}

extension UIView: Layout {
    public var layoutViews: [UIView] {
        [self]
    }
    
    public var layoutConstraints: [NSLayoutConstraint] {
        []
    }
    
    public var sublayouts: [Layout] { [self] }
}

