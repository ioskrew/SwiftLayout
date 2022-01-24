//
//  ViewTree.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

final class LayoutTree: Layoutable, Equatable {
    
    internal init(up: LayoutTree.TreeContainer = .empty, content: ContentContainer = .empty, branches: [Layoutable] = []) {
        self.up = up
        self.content = content
        self.updateBranch(branches)
    }
    
    init(_ view: UIView, @LayoutBuilder layout: () -> Layoutable) {
        self.content = .view(view)
        self.updateBranch([layout()])
    }
    
    init(_ view: UIView, content: Layoutable) {
        self.content = .view(view)
        self.updateBranch([content])
    }
   
    public static func == (lhs: LayoutTree, rhs: LayoutTree) -> Bool {
        lhs.isEqualLayout(rhs)
    }
   
    var isEmpty: Bool {
        up == .empty && content == .empty && branches.isEmpty
    }
    
    var isElement: Bool {
        content != .empty && branches.isEmpty
    }
    
    var isNode: Bool {
        content != .empty && !branches.isEmpty
    }
    
    var isRoot: Bool {
        up == .empty && content != .empty
    }
    
    var up: TreeContainer = .empty {
        didSet {
            up.addSubview(content)
        }
    }
    var content: ContentContainer = .empty
    var branches: [Layoutable] = []
    
    var trees: [LayoutTree] {
        branches.compactMap({ $0 as? LayoutTree })
    }
    
    func active() {
        trees.forEach { layout in
            layout.up = .tree(self)
            layout.active()
        }
        guard isRoot else { return }
        guard isNode else { return }
        self.clean(collectElements())
    }
    
    func collectElements() -> [LayoutTree] {
        let elements: [LayoutTree] = []
        return trees.reduce(into: elements) { elements, layout in
            if layout.isElement {
                elements.append(layout)
            } else if layout.isNode {
                elements.append(contentsOf: layout.collectElements())
            }
        }
    }
    
    func clean(_ elements: [LayoutTree]) {
        var elements = elements
        while !elements.isEmpty {
            let uniqueTree = elements.removeLast()
            elements.removeAll(where: { $0.content == uniqueTree.content })
            clean(uniqueTree)
        }
    }
    
    func clean(_ uniqueTree: LayoutTree) {
        self.branches = self.branches.filter { branch in
            guard let layout = branch as? LayoutTree else { return true }
            if layout.up != uniqueTree.up, layout.content == uniqueTree.content {
                return false
            } else if layout.isNode {
                layout.clean(uniqueTree)
                return true
            } else {
                return true
            }
        }
    }
    
    func updateBranch(_ branches: [Layoutable]) {
        if branches.count == 1, let tree = branches[0] as? LayoutTree, tree.content == .empty {
            self.updateBranch(tree.branches)
        } else {
            self.branches = branches.compactMap({ layout in
                if let tree = layout as? LayoutTree {
                    return tree
                } else if let view = layout as? UIView {
                    return LayoutTree(content: .view(view))
                } else if let constraint = layout as? SwiftLayout.Constraint {
                    return LayoutTree(content: .constraint(constraint))
                } else {
                    return nil
                }
            })
        }
    }
    
    func isEqualLayout(_ layoutable: Layoutable) -> Bool {
        guard let tree = layoutable as? LayoutTree else { return false }
        guard up.isEqual(tree.up) else { return false }
        guard content.isEqual(tree.content) else { return false }
        let left = branches.debugDescription
        let right = tree.branches.debugDescription
        return left == right
    }
    
    func isEqualView(_ layoutable: Layoutable) -> Bool {
        if let tree = layoutable as? LayoutTree {
            return content == tree.content
        } else if let view = layoutable as? UIView {
            return self.content.isEqualView(view)
        } else {
            return false
        }
    }
    
    func isEqualView(_ view: UIView?) -> Bool {
        self.content.view == view
    }
    
    public var layoutIdentifier: String {
        content.layoutIdentifier
    }
    
    var layoutIdentifierWithType: String {
        content.layoutIdentifierWithType
    }
    
    enum TreeContainer: Equatable {
        case empty
        case tree(LayoutTree)
        
        var tree: LayoutTree? {
            switch self {
            case .empty:
                return nil
            case .tree(let layoutTree):
                return layoutTree
            }
        }
        
        var root: LayoutTree? {
            if tree?.up == .empty {
                return tree
            } else {
                return tree?.up.tree
            }
        }
        
        func addSubview(_ content: ContentContainer) {
            guard let tree = tree else {
                return
            }
            tree.content.addSubcontent(content)
        }
        
        func isEqual(_ tree: TreeContainer?) -> Bool {
            guard let tree = tree else {
                return false
            }
            switch (self, tree) {
            case (.empty, .empty):
                return true
            case (.tree(let lhs), .tree(let rhs)):
                return lhs.isEqualLayout(rhs)
            default:
                return false
            }
        }
    }
    
    enum ContentContainer: Equatable, CustomDebugStringConvertible {
        case empty
        case view(UIView)
        case constraint(SwiftLayout.Constraint)
        
        var view: UIView? {
            switch self {
            case .empty:
                return nil
            case .view(let uIView):
                return uIView
            case .constraint(let constraint):
                return constraint.view
            }
        }
        
        var debugDescription: String {
            if view == nil {
                return "empty"
            } else {
                return layoutIdentifier
            }
        }
        
        func addSubcontent(_ container: ContentContainer) {
            guard let superview = self.view, let view = container.view else { return }
            superview.addSubview(view)
            
            switch (self, container) {
            case (.view(let superview), .constraint(let constraint)):
                constraint.attach(to: superview)
            case (.constraint(let constraint), .constraint(let target)):
                target.attach(to: constraint)
            case (.constraint(let constraint), .view(let view)):
                constraint.attach(from: view)
            default:
                break
            }
        }
        
        func isEqual(_ container: ContentContainer?) -> Bool {
            switch (self, container) {
            case (.empty, .empty):
                return true
            case (.view(let lhs), .view(let rhs)):
                return lhs.isEqual(rhs)
            default:
                return false
            }
        }
        
        func isEqualView(_ view: UIView) -> Bool {
            self.view == view
        }
        
        var layoutIdentifier: String {
            switch self {
            case .empty:
                return "empty"
            case .view(let uIView):
                return uIView.layoutIdentifier
            case .constraint(let constraint):
                return constraint.layoutIdentifier
            }
        }
        
        var layoutIdentifierWithType: String {
            switch self {
            case .empty:
                return "empty"
            case .view(let uIView):
                return uIView.layoutIdentifierWithType
            case .constraint(let constraint):
                return constraint.layoutIdentifier
            }
        }
    }
    
}
