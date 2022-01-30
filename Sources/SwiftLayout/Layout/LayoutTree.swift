//
//  LayoutTree.swift
//  
//
//  Created by oozoofrog on 2022/01/30.
//

import Foundation
import UIKit

public class LayoutTree: Layoutable, CustomDebugStringConvertible {
    
    internal init(view: UIView, subtree: [LayoutTree] = []) {
        self.view = view
        self.subtrees = subtree
    }
    
    deinit {
        #if DEBUG
        print("<====DEINIT LAYOUT_TREE=====>")
        print(self.debugDescription)
        print("<\\===DEINIT LAYOUT_TREE=====>")
        #endif
        deactive()
    }
    
    let view: UIView
    var subtrees: [LayoutTree]
    
    func addToParentView(to parent: UIView) {
        parent.addSubview(view)
    }
    
    @discardableResult
    public func active() -> Layoutable {
        subtrees.forEach({
            $0.addToParentView(to: view)
            $0.active()
        })
        return self
    }
    
    public func deactive() {
        subtrees.forEach({ $0.deactiveChild() })
    }
    
    public func deactiveChild() {
        view.removeFromSuperview()
        subtrees.forEach({ $0.deactiveChild() })
    }
    
    public func layoutTree(in parent: UIView) -> LayoutTree {
        self
    }
    
    public var debugDescription: String {
        var tag = TagDescriptor(view).debugDescription
        if !subtrees.isEmpty {
            let subs = subtrees.map(\.debugDescription)
            let count = tag.count
            let elementPrefix = " ".repeated(count + 3)
            let parenthesisPrefix = " ".repeated(count)
            tag += " {\n"
            tag += subs.map(elementPrefix+).joined(separator: "\n")
            tag += "\n" + parenthesisPrefix + " }\n"
        }
        return tag
    }
}
