//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import UIKit

public protocol Layout {
    var view: UIView? { get }
    var anchors: AnchorsContainer { get }
    var sublayouts: [Layout] { get }
    var option: LayoutOption? { get }
}

extension Layout {
    public var view: UIView? { nil }
    public var anchors: AnchorsContainer { AnchorsContainer() }
    public var option: LayoutOption? { nil }
}

extension Layout {
    
    ///
    /// Activate this layout.
    ///
    /// - Returns: A ``Activation`` instance, which you use when you update or deactivate layout. Deallocation of the result will deactivate layout.
    ///
    public func active(forceLayout: Bool = false) -> Activation {
        Activator.active(layout: self, forceLayout: forceLayout)
    }
    
    ///
    /// Update layout changes from the activation of the previously activated layout.
    ///
    /// - Parameter activation: The activation of the previously activated layout. It is used to identify changes in layout.
    /// - Returns: A ``Activation`` instance, which you use when you update or deactivate layout. Deallocation of the result will deactivate layout.
    ///
    public func update(fromActivation activation: Activation, forceLayout: Bool = false) -> Activation {
        Activator.update(layout: self, fromActivation: activation, forceLayout: forceLayout)
    }
    
    ///
    /// Activate this layout permanently.
    /// Until the view is released according to the lifecycle of the app
    ///
    public func finalActive(forceLayout: Bool = false) {
        Activator.finalActive(layout: self, forceLayout: forceLayout)
    }
    
    ///
    /// Wraps this layout with a type eraser.
    ///
    /// - Returns: An ``AnyLayout`` wrapping this layout.
    ///
    @available(*, deprecated, renamed: "eraseToAnyLayout()")
    public var anyLayout: AnyLayout {
        AnyLayout(self)
    }

    ///
    /// Wraps this layout with a type eraser.
    ///
    /// - Returns: An ``AnyLayout`` wrapping this layout.
    ///
    public func eraseToAnyLayout() -> AnyLayout {
        AnyLayout(self)
    }
}
