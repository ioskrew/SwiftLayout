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
    
    func addConstraint(_ constraint: NSLayoutConstraint?)
    
}

extension LayoutContainable {
    public func addConstraint(_ consrtaint: NSLayoutConstraint?) {}
}

extension LayoutContainable where Self: LayoutAttachable {
    
    public var hashable: AnyHashable {
        AnyHashable(layouts.map(\.hashable))
    }
    
}
