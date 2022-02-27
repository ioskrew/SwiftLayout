//
//  ConstraintBuilder.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation

@resultBuilder
public struct AnchorsBuilder {
    public static func buildBlock(_ components: Constraint...) -> [Constraint] {
        components
    }
    
    public static func buildIf(_ components: [Constraint]?) -> [Constraint] {
        components ?? []
    }
    
    public static func buildEither(first component: [Constraint]) -> [Constraint] {
        component
    }
    
    public static func buildEither(second component: [Constraint]) -> [Constraint] {
        component
    }
   
    public static func buildArray(_ components: [[Constraint]]) -> [Constraint] {
        components.flatMap({ $0 })
    }
    
    public static func buildOptional(_ component: [Constraint]?) -> [Constraint] {
        component ?? []
    }
}
