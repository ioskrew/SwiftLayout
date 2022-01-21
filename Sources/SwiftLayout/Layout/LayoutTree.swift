//
//  ViewTree.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

public protocol LayoutTree: CustomDebugStringConvertible {
    @discardableResult
    func active() -> LayoutTree
}

final class _LayoutTree: LayoutTree, CustomDebugStringConvertible {
    let up: LayoutTree?
    let element: LayoutElement
    let fork: LayoutFork?
    
    init(up: LayoutTree?, element: LayoutElement, fork: LayoutFork?) {
        self.up = up
        self.element = element
        self.fork = fork
    }
    
    convenience init(element: LayoutElement, @LayoutBuilder content: () -> LayoutTree) {
        self.init(up: nil, element: element, fork: nil)
    }
    
    func active() -> LayoutTree {
        element.active()
        fork?.active()
        return self
    }
    
    var debugDescription: String {
        element.view.accessibilityIdentifier ?? element.view.address
    }
    
}

protocol LayoutElement: LayoutTree {
    var view: UIView { get }
}

struct _LayoutElement: LayoutElement {
    var view: UIView
    
    func active() -> LayoutTree {
        view.active()
        return self
    }
    
    var debugDescription: String {
        view.accessibilityIdentifier ?? "\(type(of: view))(\(view.address))"
    }
}

protocol LayoutFork: LayoutTree {
    var branches: [LayoutTree] { get }
}

struct _LayoutFork: LayoutFork {
    let branches: [LayoutTree]
    
    init(_ content: LayoutTree) {
        self.branches = []
    }
    init(_ contents: [LayoutTree]) {
        self.branches = contents
    }
    
    func active() -> LayoutTree {
        branches.forEach({ $0.active() })
        return self
    }
    
    var debugDescription: String {
        branches.map(\.debugDescription).joined(separator: ", ")
    }
}
