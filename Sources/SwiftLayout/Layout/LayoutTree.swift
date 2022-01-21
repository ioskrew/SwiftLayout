//
//  ViewTree.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

public protocol LayoutTree {
    @discardableResult
    func active() -> LayoutTree
}

protocol LayoutElement: LayoutTree {
    var view: UIView { get }
}

protocol LayoutFork: LayoutTree {
    var branches: [LayoutTree] { get }
}

struct _LayoutFork: LayoutFork {
    let branches: [LayoutTree]
    
    func active() -> LayoutTree {
        branches.forEach({ $0.active() })
        return self
    }
}
