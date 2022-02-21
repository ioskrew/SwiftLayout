//
//  Constraint.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

public protocol Constraint {
    func constraints(item: NSObject, toItem: NSObject?, identifiers: ViewInformationSet?) -> [NSLayoutConstraint]
    func constraints(item: NSObject, toItem: NSObject?) -> [NSLayoutConstraint]
}

extension Array: Constraint where Element == Constraint {
    public func constraints(item: NSObject, toItem: NSObject?, identifiers: ViewInformationSet?) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for constraint in self {
            constraints.append(contentsOf: constraint.constraints(item: item, toItem: toItem, identifiers: identifiers))
        }
        return constraints
    }
    
    public func constraints(item: NSObject, toItem: NSObject?) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for constraint in self {
            constraints.append(contentsOf: constraint.constraints(item: item, toItem: toItem))
        }
        return constraints
    }
}

extension Optional: Constraint where Wrapped: Constraint {
    public func constraints(item: NSObject, toItem: NSObject?, identifiers: ViewInformationSet?) -> [NSLayoutConstraint] {
        return self?.constraints(item: item, toItem: toItem, identifiers: identifiers) ?? []
    }
    
    public func constraints(item: NSObject, toItem: NSObject?) -> [NSLayoutConstraint] {
        return self?.constraints(item: item, toItem: toItem) ?? []
    }
}
