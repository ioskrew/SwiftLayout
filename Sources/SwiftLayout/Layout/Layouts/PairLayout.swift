//
//  PairLayout.swift
//  
//
//  Created by oozoofrog on 2022/01/31.
//

import Foundation
import UIKit

public final class PairLayout<Left, Right>: LayoutAttachable, LayoutContainable where Left: LayoutAttachable, Right: LayoutAttachable {
   
    internal init(left: Left, right: Right, constraints: Set<NSLayoutConstraint> = []) {
        self.left = left
        self.right = right
        self.constraints = constraints
    }
    
    let left: Left
    let right: Right
    
    public var layouts: [LayoutAttachable] { [left, right] }
    public var constraints: Set<NSLayoutConstraint> = []
    
    public func setConstraint(_ constraints: [NSLayoutConstraint]) {
        self.constraints = Set(constraints)
    }
    
}
