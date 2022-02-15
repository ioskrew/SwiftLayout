//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

public protocol Layout: CustomDebugStringConvertible {}

extension Layout {
    
    public func active() -> Deactivable {
        return Deactivation(self)
    }
    
}

extension Layout where Self: UIView {
    
    public func callAsFunction(@LayoutBuilder _ build: () -> [Layout]) -> LayoutImpl {
        layoutImpl(build())
    }
    
    public func subviews(@LayoutBuilder _ build: () -> [Layout]) -> LayoutImpl {
        layoutImpl(build())
    }
    
    public func anchors(@AnchorsBuilder _ build: () -> [Constraint]) -> LayoutImpl {
        LayoutImpl(view: self, constraints: build())
    }
    
    public func identifying(_ identifier: String) -> LayoutImpl {
        LayoutImpl(view: self, identifier: identifier)
    }
    
    public func animationDisable() -> LayoutImpl {
        let impl = LayoutImpl(view: self)
        impl.animationDisabled = true
        return impl
    }
    
    private func layoutImpl(_ layouts: [Layout]) -> LayoutImpl {
        let sublayouts: [LayoutImpl] = layouts.compactMap { layout in
            if let view = layout as? UIView {
                return LayoutImpl(view: view)
            } else {
                return layout as? LayoutImpl
            }
        }
        return LayoutImpl(view: self, sublayouts: sublayouts)
    }
}

extension Layout where Self: LayoutImpl {
    
    public func callAsFunction(@LayoutBuilder _ build: () -> [Layout]) -> Self {
        layoutImpl(build())
    }
    
    public func subviews(@LayoutBuilder _ build: () -> [Layout]) -> Self {
        layoutImpl(build())
    }
    
    public func anchors(@AnchorsBuilder _ build: () -> [Constraint]) -> Self {
        appendConstraints(build())
        return self
    }
    
    public func identifying(_ identifier: String) -> Self {
        self.identifier = identifier
        return self
    }
    
    public func animationDisable() -> Self {
        self.animationDisabled = true
        return self
    }
    
    private func layoutImpl(_ layouts: [Layout]) -> Self {
        let sublayouts: [LayoutImpl] = layouts.compactMap { layout in
            if let view = layout as? UIView {
                return LayoutImpl(view: view)
            } else {
                return layout as? LayoutImpl
            }
        }
        self.appendSublayouts(sublayouts)
        return self
    }
}

extension UIView: Layout {}

extension Array: Layout where Element == Layout {}
