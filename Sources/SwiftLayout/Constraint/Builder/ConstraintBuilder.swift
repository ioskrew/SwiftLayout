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
    
    public static func buildBlock(_ components: Binding...) -> [Binding] {
        components
    }
   
    public typealias Binding = ConstraintBinding
}

extension Array: Constraint where Element == ConstraintBuilder.Binding {
    public func constraints(item: AnyObject, toItem: AnyObject?) -> [NSLayoutConstraint] {
        map { binding in
            binding.constraint(item: item, toItem: toItem)
        }
    }
}
