//
//  Anchors.swift
//  
//
//  Created by aiden_h on 2022/03/27.
//

import UIKit

public final class Anchors {
    
    public private(set) var constraints: [AnchorsConstraintProperty]
    
    init(_ constraints: [AnchorsConstraintProperty] = []) {
        self.constraints = constraints
    }

    func append(_ container: Anchors) {
        self.constraints.append(contentsOf: container.constraints)
    }
    
    func constraints(item fromItem: NSObject, toItem: NSObject?, viewDic: [String: UIView] = [:]) -> [NSLayoutConstraint] {
        constraints.map {
            $0.nsLayoutConstraint(item: fromItem, toItem: toItem, viewDic: viewDic)
        }
    }
    
    public func multiplier(_ multiplier: CGFloat) -> Self {
        for i in 0..<constraints.count {
            constraints[i].multiplier = multiplier
        }
        return self
    }
    
    public func priority(_ priority: UILayoutPriority) -> Self {
        for i in 0..<constraints.count {
            constraints[i].priority = priority
        }
        return self
    }
}
