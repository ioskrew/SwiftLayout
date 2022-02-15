//
//  NSLayoutConstraint+Constraint.swift
//  
//
//  Created by oozoofrog on 2022/02/09.
//

import Foundation
import UIKit

extension NSLayoutConstraint: Constraint {
    public func constraints(item: NSObject, toItem: NSObject?, identifiers: ViewIdentifiers?) -> [NSLayoutConstraint] {
        [self]
    }
    
    public func constraints(item: NSObject, toItem: NSObject?) -> [NSLayoutConstraint] {
        [self]
    }
}
