//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import UIKit

public protocol Layout: CustomDebugStringConvertible {
    var view: UIView? { get }
    var anchors: Anchors? { get }
    var sublayouts: [Layout] { get }
}

extension Layout {
    public var view: UIView? { nil }
    public var anchors: Anchors? { nil }
}

extension Layout {
    public func active() -> Activation {
        Activator.active(layout: self)
    }
    
    public func update(fromActivation activation: Activation) -> Activation {
        Activator.update(layout: self, fromActivation: activation)
    }
    
    public func finalActive() {
        Activator.finalActive(layout: self)
    }
    
    public var anyLayout: AnyLayout {
        AnyLayout(self)
    }
    
    public func updateIdentifiers(rootObject: AnyObject) -> some Layout {
        IdentifierUpdater.nameOnly.update(rootObject)
        return self
    }
}
