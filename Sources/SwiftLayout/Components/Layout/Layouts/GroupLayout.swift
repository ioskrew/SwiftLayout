//
//  GroupLayout.swift
//  
//
//  Created by oozoofrog on 2022/03/01.
//

import Foundation
import UIKit

public struct GroupLayout<L: Layout>: Layout {
    
    let layout: L
    
    public init(@LayoutBuilder _ handler: () -> L) {
        self.layout = handler()
    }
    
    public var debugDescription: String {
        "GroupLayout"
    }
}

extension GroupLayout {
    public func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        layout.traverse(superview, traverseHandler: handler)
    }
    
    public func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler) {
        layout.traverse(superview, constraintHndler: handler)
    }
}
