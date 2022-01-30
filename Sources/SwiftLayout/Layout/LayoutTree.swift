//
//  LayoutTree.swift
//  
//
//  Created by oozoofrog on 2022/01/30.
//

import Foundation
import UIKit

public class LayoutTree: Layoutable, CustomDebugStringConvertible, Hashable {
    
    public static func == (lhs: LayoutTree, rhs: LayoutTree) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    internal init(view: UIView, subtree: [LayoutTree] = []) {
        self.view = view
        self.subtrees = subtree
    }
    
    deinit {
        deactive()
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    private let uuid = UUID()
    
    private var parentTree: ParentTree = .none
    let view: UIView
    var subtrees: [LayoutTree]
    
    func attachToParent(_ parent: LayoutTree) {
        parent.view.addSubview(view)
        parentTree = .tree(parent)
        subtrees.forEach { tree in
            tree.attachToParent(self)
        }
        #if DEBUG
        print(parent.view.tagDescription + " <- " + view.tagDescription)
        #endif
    }
    
    func detachFromParent(_ parent: LayoutTree) {
        if parentTree == .tree(parent) {
            if view.superview == parent.view {
                view.removeFromSuperview()
            }
            parentTree = .none
        }
        #if DEBUG
        print(parent.view.tagDescription + " <|> " + view.tagDescription)
        #endif
    }
    
    @discardableResult
    public func active() -> AnyLayoutable {
        subtrees.forEach { tree in
            tree.attachToParent(self)
        }
        return AnyLayoutable(self)
    }
    
    public func deactive() {
        subtrees.forEach { tree in
            tree.detachFromParent(self)
        }
    }
    
    public func layoutTree(in parent: UIView) -> LayoutTree {
        self
    }
    
    public var equation: AnyHashable {
        AnyHashable(uuid)
    }
    
    public var debugDescription: String {
        tagDescription(prefix: "")
    }
    
    private func tagDescription(prefix: String) -> String {
        var description = prefix + view.tagDescription
        if !subtrees.isEmpty {
            description += "\n"
            description += subtrees.map({ $0.tagDescription(prefix: prefix + "\t") }).joined(separator: "\n")
        }
        return description
    }
    
    enum ParentTree: Hashable {
        case none
        case tree(LayoutTree)
    }
}

extension Collection where Element: LayoutTree, Self: CustomDebugStringConvertible, Self: CustomStringConvertible {
    
    public var description: String {
        debugDescription
    }
    
    public var debugDescription: String {
        map(\.debugDescription).joined(separator: ", ")
    }
    
}
