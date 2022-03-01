//
//  Optional+Layout.swift
//  
//
//  Created by aiden_h on 2022/02/21.
//

import UIKit

extension Optional: Layout where Wrapped: Layout {
    public func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        self?.traverse(superview, traverseHandler: handler)
    }
    
    public func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler) {
        self?.traverse(superview, constraintHndler: handler)
    }
}

