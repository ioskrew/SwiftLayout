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

protocol LayoutTreeLink: LayoutTree {
    func linkToTree(_ tree: _LayoutTree)
}

protocol LayoutElement: LayoutTreeLink {
    var view: UIView { get }
}

extension LayoutElement {
    func linkToTree(_ tree: _LayoutTree) {
        tree.element.view.addSubview(view)
    }
}

struct _LayoutElement: LayoutElement {
    var view: UIView
    
    func active() -> LayoutTree {
        view.active()
        return self
    }
}

protocol LayoutFork: LayoutTreeLink {
    var branches: [LayoutTreeLink] { get }
}

extension LayoutFork {
    func linkToTree(_ tree: _LayoutTree) {
        branches.forEach({ $0.linkToTree(tree) })
    }
}

struct _LayoutFork: LayoutFork {
    let branches: [LayoutTreeLink]
    
    init(element: LayoutElement) {
        self.branches = [element]
    }
    
    init(view: UIView) {
        self.branches = [_LayoutElement(view: view)]
    }
    
    init(branches: [LayoutTree]) {
        self.branches = branches.compactMap({ tree in
            if let view = tree as? UIView {
                return _LayoutElement(view: view)
            } else if let link = tree as? LayoutTreeLink {
                return link
            } else {
                return nil
            }
        })
    }
    
    func active() -> LayoutTree {
        branches.forEach({ $0.active() })
        return self
    }
}

struct _LayoutTree: LayoutTreeLink {
    var up: LayoutTree?
    var element: LayoutElement
    var fork: LayoutFork?
    
    init(up: LayoutTree? = nil, element: LayoutElement, fork: LayoutFork? = nil) {
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
    
    func linkToTree(_ tree: _LayoutTree) {
        
    }
}
