//
//  Constraint.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

public protocol Constraint {
    func constraints(item: AnyObject, toItem: AnyObject?) -> [NSLayoutConstraint]
}

extension Array: Constraint where Element == Constraint {
    public func constraints(item: AnyObject, toItem: AnyObject?) -> [NSLayoutConstraint] {
        flatMap { constraint in
            constraint.constraints(item: item, toItem: toItem)
        }
    }
}
