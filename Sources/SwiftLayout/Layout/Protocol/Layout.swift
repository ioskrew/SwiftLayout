//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import UIKit

public protocol Layout: CustomDebugStringConvertible {}

public extension Layout {
    func callAsFunction(@LayoutBuilder _ build: () -> [Layout]) -> Layout {
        return LayoutImp(layout: self, sublayouts: build())
    }
    
    func subviews(@LayoutBuilder _ build: () -> [Layout]) -> Layout {
        return LayoutImp(layout: self, sublayouts: build())
    }
    
    func anchors(@AnchorsBuilder _ anchors: () -> [Constraint]) -> Layout {
        return LayoutImp(layout: self, anchors: anchors())
    }
    
    func identifying(_ identifier: String) -> Layout {
        var layoutImp = LayoutImp(layout: self)
        layoutImp?.identifier = identifier
        return layoutImp
    }
    
    func animationDisable() -> Layout {
        var layoutImp = LayoutImp(layout: self)
        layoutImp?.animationDisabled = true
        return layoutImp
    }
}

extension Layout {
    public func active(_ options: LayoutOptions = []) -> Deactivable {
        Activator.active(layout: extractLayoutImpFromSelf(), options: options)
    }
    
    func extractLayoutImpFromSelf() -> [LayoutImp] {
        if let layoutImps = self as? [LayoutImp] {
            return layoutImps
        } else if let layoutImp = self as? LayoutImp {
            return [layoutImp]
        } else if let layoutImp = LayoutImp(layout: self) {
            return [layoutImp]
        } else {
            return []
        }
    }
}

extension UIView: Layout {}

extension Array: Layout where Element == Layout {}

extension Optional: Layout where Wrapped: Layout {}
