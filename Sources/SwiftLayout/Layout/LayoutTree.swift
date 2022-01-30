//
//  LayoutTree.swift
//  
//
//  Created by oozoofrog on 2022/01/30.
//

import Foundation
import UIKit

public class LayoutTree: Layoutable {
    
    internal init(view: UIView, subtree: [LayoutTree] = []) {
        self.view = view
        self.subtree = subtree
    }
    
    let view: UIView
    var subtree: [LayoutTree]
    
    func addToParentView(to parent: UIView) {
        parent.addSubview(view)
    }
    
    @discardableResult
    public func active() -> Layoutable {
        subtree.forEach({
            $0.addToParentView(to: view)
            $0.active()
        })
        return self
    }
    
    public func layoutTree(in parent: UIView) -> LayoutTree {
        self
    }
    
}
