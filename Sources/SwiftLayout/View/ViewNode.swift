//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

public protocol ViewNodable {}

extension UIView: ViewNodable {}

extension ViewNodable {
    var node: ViewNode {
        if let node = self as? ViewNode {
            return node
        } else if let view = self as? UIView {
            return ViewChild(child: view)
        } else {
            fatalError()
        }
    }
}

public protocol ViewNode: CustomDebugStringConvertible, ViewNodable {
    func addToParent(_ parentView: UIView)
    @discardableResult
    func active() -> ViewNode
}

protocol _ViewChildren: ViewNode {
    var children: [ViewNode] { get }
}

protocol _ViewNode: _ViewChildren {
    var root: UIView { get }
}

struct ViewRoot: _ViewNode {
    
    internal init(root: UIView, children: [ViewNode]) {
        self.root = root
        self.children = children
    }
    
    internal init(root: UIView, child: ViewNode) {
        self.init(root: root, children: [child])
    }
    
    let root: UIView
    let children: [ViewNode]
    
    func addToParent(_ parentView: UIView) {}
    
    func active() -> ViewNode {
        children.forEach({
            $0.addToParent(root)
            $0.active()
        })
        return self
    }
    
    var debugDescription: String {
        let children = children.map(\.debugDescription).filter({ !$0.isEmpty }).joined(separator: ", ")
        return "\(root.accessibilityIdentifier ?? root.debugDescription): [\(children)]"
    }
}

struct ViewParent: _ViewNode {
    
    internal init(root: UIView, children: [ViewNode]) {
        self.root = root
        self.children = children
    }
    
    internal init(root: UIView, child: ViewNode) {
        self.init(root: root, children: [child])
    }
    
    let root: UIView
    let children: [ViewNode]
    
    func addToParent(_ parentView: UIView) {
        parentView.addSubview(root)
    }
    
    func active() -> ViewNode {
        children.forEach({
            $0.addToParent(root)
            $0.active()
        })
        return self
    }
    
    var debugDescription: String {
        guard root.superview != nil else { return "" }
        let children = children.map(\.debugDescription).filter({ !$0.isEmpty }).joined(separator: ", ")
        return "\(root.accessibilityIdentifier ?? root.debugDescription): [\(children)]"
    }
}

class ViewChild: ViewNode {
    var parent: UIView?
    let child: UIView
    
    init(child: UIView) {
        self.child = child
    }
    
    func addToParent(_ parentView: UIView) {
        print("\(child.accessibilityIdentifier!) is add to \(parentView.accessibilityIdentifier!)")
        self.parent = parentView
        parentView.addSubview(child)
    }
    
    func active() -> ViewNode {
        child.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    var debugDescription: String {
        guard child.superview == parent else { return "" }
        return child.accessibilityIdentifier ?? child.debugDescription
    }
}

struct ViewChildren: ViewNode {
    let children: [ViewNode]
    
    func addToParent(_ parentView: UIView) {
        children.forEach({ $0.addToParent(parentView) })
    }
    
    func active() -> ViewNode {
        children.forEach({
            $0.active()
        })
        return self
    }
    
    var debugDescription: String {
        children.map(\.debugDescription).filter({ !$0.isEmpty }).joined(separator: ", ")
    }
}
