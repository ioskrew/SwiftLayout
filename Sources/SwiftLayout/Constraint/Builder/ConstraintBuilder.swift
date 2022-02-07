//
//  ConstraintBuilder.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

@resultBuilder
public struct ConstraintBuilder {
    
    public static func buildBlock(_ components: Anchor...) -> [Anchor] {
        components
    }
   
}

extension Array: Constraint where Element == Anchor {
    public func constraints(item: AnyObject, toItem: AnyObject?) -> [NSLayoutConstraint] {
        flatMap { anchor in
            anchor.constraints(item: item, toItem: toItem)
        }
    }
}
