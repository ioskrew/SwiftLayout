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
    
    public func active() -> Layoutable {
        self
    }
    
    public func layoutTree(in parent: UIView) -> LayoutTree {
        self
    }
    
}
