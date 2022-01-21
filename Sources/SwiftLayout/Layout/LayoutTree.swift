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
    
    convenience init(_ view: UIView, content: @autoclosure () -> Layoutable) {
        self.init(view: .view(view), branches: [content()])
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
        
        func addSubview(_ view: ViewContainer) {
            guard let tree = tree else {
                return
            }
            tree.view.addSubview(view)
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
    
    var up: TreeContainer = .empty {
        didSet {
            up.addSubview(view)
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
            self.updateBranch(tree.branches)
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
    
    public var layoutIdentifier: String {
        view.layoutIdentifier
    }
    
    var layoutIdentifierWithType: String {
        view.layoutIdentifierWithType
    }
}
