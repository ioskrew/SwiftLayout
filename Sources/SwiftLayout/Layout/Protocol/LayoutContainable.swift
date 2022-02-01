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
    
    public var equation: AnyHashable {
        AnyHashable(layouts.map(\.equation))
    }
    
}
