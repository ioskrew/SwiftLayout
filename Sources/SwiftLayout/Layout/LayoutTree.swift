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
        print("<deinit LayoutTree>")
        print(self.tagDescription(prefix: "\t"))
        print("</deinit LayoutTree>")
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
