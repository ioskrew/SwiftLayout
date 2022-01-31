//
//  LayoutCoditional.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation

public protocol LayoutConditional: LayoutAttachable, LayoutContainable {
    
    associatedtype TrueLayout: LayoutAttachable
    associatedtype FalseLayout: LayoutAttachable
    
    var layout: LayoutAttachable { get }
    
}
