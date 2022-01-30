//
//  LayoutTree.swift
//  
//
//  Created by oozoofrog on 2022/01/30.
//

import Foundation
import UIKit

public class LayoutTree: Layoutable, CustomDebugStringConvertible, Equatable {
    
    public static func == (lhs: LayoutTree, rhs: LayoutTree) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    internal init(view: UIView, subtree: [LayoutTree] = []) {
        self.view = view
        self.subtrees = subtree
    }
    
    deinit {
        #if DEBUG
        print("<deinit LayoutTree>")
        print(self.tagDescription(prefix: "\t"))
        print("</deinit LayoutTree>")
        #endif
        deactive()
    }
    
    private let uuid = UUID()
    
    private weak var parentTree: LayoutTree?
    let view: UIView
    var subtrees: [LayoutTree]
    
    func addToParentView(to parent: LayoutTree) {
        parent.view.addSubview(view)
        parentTree = parent
    }
    
    @discardableResult
    public func active() -> Layoutable {
        subtrees.forEach({
            $0.addToParentView(to: self)
            $0.active()
        })
        return self
    }
    
    public func deactive() {
        if parentTree != nil {
            view.removeFromSuperview()
        }
        subtrees.forEach({ $0.deactive() })
    }
    
    public func layoutTree(in parent: UIView) -> LayoutTree {
        self
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
    
}

extension Collection where Element: LayoutTree, Self: CustomDebugStringConvertible, Self: CustomStringConvertible {
    
    public var description: String {
        debugDescription
    }
    
    public var debugDescription: String {
        map(\.debugDescription).joined(separator: ", ")
    }
    
}
