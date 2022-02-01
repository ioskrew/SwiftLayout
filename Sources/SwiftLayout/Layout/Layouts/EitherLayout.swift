//
//  ConditionalLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation

public struct EitherFirstLayout<First, Second>: LayoutAttachable, LayoutContainable where First: LayoutAttachable, Second: LayoutAttachable {
    
    var layout: First
    
    public var layouts: [LayoutAttachable] { [layout] }
    
}

public struct EitherSecondLayout<First, Second>: LayoutAttachable, LayoutContainable where First: LayoutAttachable, Second: LayoutAttachable {
    
    var layout: Second
    
    public var layouts: [LayoutAttachable] { [layout] }
    
}
