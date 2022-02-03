//
//  ConditionalLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation

public struct EitherLayout<First, Second>: LayoutAttachable, LayoutContainable where First: LayoutAttachable, Second: LayoutAttachable {
    
    var layout: LayoutAttachable
    
    public var layouts: [LayoutAttachable] { [layout] }
    
    public func attachConstraint(_ constraint: LayoutConstraintAttachable) {
        layouts.forEach { layout in
            layout.attachConstraint(constraint)
        }
    }
}
