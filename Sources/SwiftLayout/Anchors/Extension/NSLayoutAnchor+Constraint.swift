//
//  NSLayoutAnchor+Constraint.swift
//  
//
//  Created by oozoofrog on 2022/02/09.
//

import Foundation
import UIKit

extension NSLayoutAnchor: AnchorTypeInterface {}

extension Constraint where Self: AnchorTypeInterface {
    public func constraints(item: NSObject, toItem: NSObject?) -> [NSLayoutConstraint] {
        if let toItem = toItem, let constraint = anchorType.constraint(to: toItem) {
            return [constraint]
        } else {
            return []
        }
    }
    
    public var hashable: AnyHashable {
        AnyHashable(anchorType)
    }
}

extension NSLayoutXAxisAnchor: Constraint {}
extension NSLayoutYAxisAnchor: Constraint {}
extension NSLayoutDimension: Constraint {}
