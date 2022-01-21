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

struct _LayoutElement: LayoutElement {
    var view: UIView
    
    func active() -> LayoutTree {
        view.active()
        return self
    }
}

protocol LayoutFork: LayoutTree {
    var branches: [LayoutTree] { get }
    func linkToTree(_ tree: _LayoutTree)
}

struct _LayoutFork: LayoutFork {
    let branches: [LayoutTree]
    
    init(element: LayoutElement) {
        self.branches = [element]
    }
    
    init(view: UIView) {
        self.branches = [_LayoutElement(view: view)]
    }
    
    init(branches: [LayoutTree]) {
        self.branches = branches.map({ tree in
            if let view = tree as? UIView {
                return _LayoutElement(view: view)
            } else {
                return tree
            }
        })
    }
    
    func active() -> LayoutTree {
        branches.forEach({ $0.active() })
        return self
    }
    
    func linkToTree(_ tree: _LayoutTree) {
        
    }
}

struct _LayoutTree: LayoutTree {
    let up: LayoutTree?
    let element: LayoutElement
    let fork: LayoutFork?
    
    init(up: LayoutTree?, element: LayoutElement, fork: LayoutFork?) {
        self.up = up
        self.element = element
        self.fork = fork
    }
    
    init(element: LayoutElement, @LayoutBuilder content: () -> LayoutTree) {
        let tree = content()
        if let forkContent = tree as? LayoutFork {
            self.init(up: nil, element: element, fork: forkContent)
        } else if let elementContent = tree as? LayoutElement {
            self.init(up: nil, element: element, fork: _LayoutFork(element: elementContent))
        } else if let viewContent = tree as? UIView {
            self.init(up: nil, element: element, fork: _LayoutFork(view: viewContent))
        } else {
            self.init(up: nil, element: element, fork: nil)
        }
    }
    
    func active() -> LayoutTree {
        element.active()
        fork?.active()
        fork?.linkToTree(self)
        return self
    }
}
