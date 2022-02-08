//
//  ConstraintBuilder.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

@resultBuilder
public struct AnchorsBuilder {
    
    public static func buildBlock(_ components: Anchors...) -> [Anchors] {
        components
    }
    
    public static func buildArray(_ components: [[Anchors]]) -> [Anchors] {
        components.flatMap({ $0 })
    }
    
    public static func buildOptional(_ component: [Anchors]?) -> [Anchors] {
        component ?? []
    }
    
    public static func buildEither(first component: [Anchors]) -> [Anchors] {
        component
    }
    
    public static func buildEither(second component: [Anchors]) -> [Anchors] {
        component
    }
   
}

extension Array: Constraint where Element == Anchors {
    public func constraints(item: AnyObject, toItem: AnyObject?) -> [NSLayoutConstraint] {
        flatMap { anchor in
            anchor.constraints(item: item, toItem: toItem)
        }
    }
}
