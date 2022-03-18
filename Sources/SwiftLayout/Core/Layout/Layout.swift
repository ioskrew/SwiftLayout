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
    
    ///
    /// Activate this layout.
    ///
    /// - Returns: A ``Activation`` instance, which you use when you update or deactivate layout. Deallocation of the result will deactivate layout.
    ///
    public func active() -> Activation {
        Activator.active(layout: self)
    }
    
    ///
    /// Update layout changes from the activation of the previously activated layout.
    ///
    /// - Parameter activation: The activation of the previously activated layout. It is used to identify changes in layout.
    /// - Returns: A ``Activation`` instance, which you use when you update or deactivate layout. Deallocation of the result will deactivate layout.
    ///
    public func update(fromActivation activation: Activation) -> Activation {
        Activator.update(layout: self, fromActivation: activation)
    }
    
    ///
    /// Activate this layout permanently.
    /// Until the view is released according to the lifecycle of the app
    ///
    public func finalActive() {
        Activator.finalActive(layout: self)
    }
    
    ///
    /// Wraps this layout with a type eraser.
    ///
    /// - Returns: An ``AnyLayout`` wrapping this layout.
    ///
    public var anyLayout: AnyLayout {
        AnyLayout(self)
    }
    
    ///
    /// Set the **accessibilityIdentifier** of all view objects included in the layout hierarchy to the property name of the object that has each views.
    ///
    /// - Parameter rootObject: root object for referencing property names
    /// - Returns: The layout itself with the **accessibilityIdentifier** applied
    ///
    public func updateIdentifiers(rootObject: AnyObject) -> some Layout {
        IdentifierUpdater.nameOnly.update(rootObject)
        return self
    }
}
