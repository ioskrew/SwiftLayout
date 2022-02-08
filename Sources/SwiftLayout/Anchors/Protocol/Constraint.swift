//
//  Constraint.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

public protocol Constraint {
    func constraints(item: NSObject, toItem: NSObject?) -> [NSLayoutConstraint]
    var hashable: AnyHashable { get }
}

extension Array: Constraint where Element == Constraint {
    public func constraints(item: NSObject, toItem: NSObject?) -> [NSLayoutConstraint] {
        flatMap { constraint in
            constraint.constraints(item: item, toItem: toItem)
        }
    }
    public var hashable: AnyHashable {
        AnyHashable(map(\.hashable))
    }
}
