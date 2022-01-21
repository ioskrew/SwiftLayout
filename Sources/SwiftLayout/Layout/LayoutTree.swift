//
//  ViewTree.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

public protocol Layoutable {
    func isEqualLayout(_ layoutable: Layoutable) -> Bool
}

public final class LayoutTree: Layoutable, Equatable {
    
    internal init(up: LayoutTree.TreeContainer = .empty, view: ViewContainer = .empty, branches: [Layoutable] = []) {
        self.up = up
        self.view = view
        self.updateBranch(branches)
    }
    
    public static func == (lhs: LayoutTree, rhs: LayoutTree) -> Bool {
        lhs.isEqualLayout(rhs)
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
    }
    
    var up: TreeContainer = .empty {
        didSet {
            up.tree?.view.addSubview(view)
            branches.forEach({
                if let tree = $0 as? LayoutTree {
                    tree.up = .tree(self)
                }
            })
        }
    }
    var view: ViewContainer = .empty
    var branches: [Layoutable] = []
    
    func updateBranch(_ branches: [Layoutable]) {
        if branches.count == 1, let tree = branches[0] as? LayoutTree, tree.view == .empty {
            self.branches = tree.branches
        } else {
            self.branches = branches.compactMap({ layout in
                if let view = layout as? UIView {
                    let tree = LayoutTree(view: .view(view))
                    tree.up = .tree(self)
                    return tree
                } else if let tree = layout as? LayoutTree {
                    tree.up = .tree(self)
                    return tree
                } else {
                    return nil
                }
            })
        }
    }
    
    public func isEqualLayout(_ layoutable: Layoutable) -> Bool {
        guard let tree = layoutable as? LayoutTree else { return false }
        return up == tree.up && view == tree.view && branches.elementsEqual(tree.branches, by: { lhs, rhs in
            lhs.isEqualLayout(rhs)
        })
    }
}
