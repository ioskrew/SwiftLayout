//
//  LayoutContainable.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation
import UIKit

public protocol LayoutContainable {
    
    var layouts: [LayoutAttachable] { get }
    var constraints: Set<NSLayoutConstraint> { get }
    
    func addConstraint(_ constraints: [NSLayoutConstraint])
    
}

extension LayoutContainable {
    public func addConstraint(_ constraints: [NSLayoutConstraint]) {}
}

extension LayoutContainable where Self: LayoutAttachable {
    
    public var hashable: AnyHashable {
        AnyHashable(layouts.map(\.hashable))
    }
    
}
