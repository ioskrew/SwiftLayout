//
//  LayoutContainable.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation

public protocol LayoutContainable {
    
    var layouts: [LayoutAttachable] { get }
    
}

extension LayoutContainable where Self: LayoutAttachable {
    
    public var hashable: AnyHashable {
        AnyHashable(layouts.map(\.hashable))
    }
    
}
