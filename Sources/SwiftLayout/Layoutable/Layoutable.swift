//
//  Layoutable.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public protocol Layoutable: AnyObject {
    associatedtype LayoutBody: Layout
    var activation: Activation? { get set }
    @LayoutBuilder var layout: LayoutBody { get }
}

public extension Layoutable {
    
    func updateLayout() {
        self.activation = Activator.update(layout: layout, fromActivation: activation ?? Activation())
    }
}
