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
    var node: _ViewNode {
        if let view = self as? UIView {
            return _ViewNode(parent: .view(view))
        } else if let node = self as? _ViewNode {
            return node
        } else {
            return _ViewNode()
        }
    }
}

enum ViewNodeParent: Equatable, CustomDebugStringConvertible {
    case empty
    case root(UIView)
    case view(UIView)
    
    var isRoot: Bool {
        switch self {
        case .root:
            return true
        default:
            return false
        }
    }
    
    func view(_ handle: (UIView) -> Void) {
        switch self {
        case .empty:
            return
        case let .root(view):
            handle(view)
        case let .view(view):
            handle(view)
        }
    }
    
    var debugDescription: String {
        switch self {
        case .empty:
            return ""
        case .root(let view):
            return view.accessibilityIdentifier ?? view.address
        case .view(let view):
            return view.accessibilityIdentifier ?? view.address
        }
    }
    
}

enum ViewNodeChild: Equatable, CustomDebugStringConvertible {
    case empty
    case child(_ViewNode)
    case children([_ViewNode])
    
    func forEach(_ body: (_ViewNode) -> Void) {
        switch self {
        case let .child(node):
            body(node)
        case let .children(nodes):
            nodes.forEach(body)
        default:
            break
        }
    }
    
    func appendParent(_ parent: ViewNodeParent) {
        forEach { child in
            child.updateParent(parent)
        }
    }
    
    var debugDescription: String {
        switch self {
        case .empty:
            return ""
        case .child(let node):
            return node.debugDescription
        case .children(let nodes):
            return ": [\(nodes.map(\.debugDescription).joined(separator: ", "))]"
        }
    }
}

public protocol ViewNode: CustomDebugStringConvertible, ViewNodable {
    @discardableResult
    func active() -> ViewNode
}

protocol ViewNodeChain: ViewNode {
    var parent: ViewNodeParent { get }
    var child: ViewNodeChild { get }
    
    func updateParent(_ parent: ViewNodeParent)
    
    func isSubviewOfParent(_ view: UIView) -> Bool
}

extension ViewNodeChain {
    func isSubviewOfParent(_ view: UIView) -> Bool {
        false
    }
    
    public var debugDescription: String {
        if child == .empty {
            return parent.debugDescription
        } else {
            return "\(parent.debugDescription)\(child.debugDescription)"
        }
    }
}

extension ViewNodeChain {
    
    var isRoot: Bool { parent.isRoot }
    
    func addSubviewToParentNode(_ upperView: UIView? = nil) {
        parent.view { view in
            if let upperView = upperView {
                upperView.addSubview(view)
            }
            child.forEach { node in
                node.addSubviewToParentNode(view)
            }
        }
    }
    
    public func active() -> ViewNode {
        addSubviewToParentNode()
        return self
    }
}

final class _ViewNode: ViewNodeChain, Equatable {
    static func == (lhs: _ViewNode, rhs: _ViewNode) -> Bool {
        lhs.parent == rhs.parent && lhs.child == rhs.child
    }
    
    init(parent: ViewNodeParent = .empty, child: ViewNodeChild = .empty) {
        self.parent = parent
        self.child = child
    }
    
    var parent: ViewNodeParent
    let child: ViewNodeChild
    
    func updateParent(_ parent: ViewNodeParent) {
        self.parent = parent
    }
}
