//
//  ViewTree.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

public protocol Layoutable: CustomDebugStringConvertible {
    
    var branches: [Layoutable] { get }
    
    func isEqualLayout(_ layoutable: Layoutable) -> Bool
    func isEqualView(_ layoutable: Layoutable) -> Bool
    func isEqualView(_ view: UIView?) -> Bool
    
    var layoutIdentifier: String { get }
    var layoutIdentifierWithType: String { get }
}

extension Layoutable {
    public var branches: [Layoutable] { [] }
}

final class LayoutTree: Layoutable, Equatable {
    
    internal init(up: LayoutTree.TreeContainer = .empty, view: ViewContainer = .empty, branches: [Layoutable] = []) {
        self.up = up
        self.view = view
        self.updateBranch(branches)
    }
    
    init(_ view: UIView, @LayoutBuilder layout: () -> Layoutable) {
        self.view = .view(view)
        self.updateBranch([layout()])
    }
    
    init(_ view: UIView, content: Layoutable) {
        self.view = .view(view)
        self.updateBranch([content])
    }
   
    public static func == (lhs: LayoutTree, rhs: LayoutTree) -> Bool {
        lhs.isEqualLayout(rhs)
    }
   
    var isEmpty: Bool {
        up == .empty && view == .empty && branches.isEmpty
    }
    
    var up: TreeContainer = .empty {
        didSet {
            up.addSubview(view)
            up.cleanDuplicatedViewBranches(self)
        }
    }
    var view: ViewContainer = .empty
    var branches: [Layoutable] = []
    
    func active() {
        branches.compactMap({ $0 as? LayoutTree }).forEach { layout in
            layout.up = .tree(self)
            layout.active()
        }
    }
    
    func updateBranch(_ branches: [Layoutable]) {
        if branches.count == 1, let tree = branches[0] as? LayoutTree, tree.view == .empty {
            self.updateBranch(tree.branches)
        } else {
            self.branches = branches.compactMap({ layout in
                if let view = layout as? UIView {
                    let tree = LayoutTree(view: .view(view))
                    return tree
                } else if let tree = layout as? LayoutTree {
                    return tree
                } else {
                    return nil
                }
            })
        }
    }
    
    func isEqualLayout(_ layoutable: Layoutable) -> Bool {
        guard let tree = layoutable as? LayoutTree else { return false }
        guard up.isEqual(tree.up) else { return false }
        guard view.isEqual(tree.view) else { return false }
        let left = branches.debugDescription
        let right = tree.branches.debugDescription
        return left == right
    }
    
    func isEqualView(_ layoutable: Layoutable) -> Bool {
        if let tree = layoutable as? LayoutTree {
            return view == tree.view
        } else if let view = layoutable as? UIView {
            return self.view.isEqualView(view)
        } else {
            return false
        }
    }
    
    func isEqualView(_ view: UIView?) -> Bool {
        self.view.view == view
    }
    
    public var layoutIdentifier: String {
        view.layoutIdentifier
    }
    
    var layoutIdentifierWithType: String {
        view.layoutIdentifierWithType
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
        
        func addSubview(_ view: ViewContainer) {
            guard let tree = tree else {
                return
            }
            tree.view.addSubview(view)
        }
        
        func cleanDuplicatedViewBranches(_ tree: LayoutTree) {
            guard let root = root else {
                return
            }
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
    
    enum ViewContainer: Equatable, CustomDebugStringConvertible {
        case empty
        case view(UIView)
        
        var view: UIView? {
            switch self {
            case .empty:
                return nil
            case .view(let uIView):
                return uIView
            }
        }
        
        var debugDescription: String {
            guard let view = view else {
                return "empty"
            }
            return "\(view.accessibilityIdentifier ?? view.address)(\(type(of: view)))"
        }
        
        func addSubview(_ container: ViewContainer) {
            guard let superview = view, let subview = container.view else { return }
            superview.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        func isEqual(_ container: ViewContainer?) -> Bool {
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
            }
        }
        
        var layoutIdentifierWithType: String {
            switch self {
            case .empty:
                return "empty"
            case .view(let uIView):
                return uIView.layoutIdentifierWithType
            }
        }
    }
    
}
