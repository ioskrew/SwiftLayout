//
//  ConstraintBuilder.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

@resultBuilder
public struct AnchorsBuilder {
    public static func buildBlock(_ components: Anchors...) -> Anchors {
        components.reduce(Anchors(), +)
    }
    
    public static func buildEither(first component: Anchors) -> Anchors {
        component
    }
    
    public static func buildEither(second component: Anchors) -> Anchors {
        component
    }
   
    public static func buildArray(_ components: [Anchors]) -> Anchors {
        components.reduce(Anchors(), +)
    }
    
    public static func buildOptional(_ component: Anchors?) -> Anchors {
        component ?? Anchors()
    }
    
    public static func buildExpression(_ expression: Anchors?) -> Anchors {
        expression ?? Anchors()
    }
}
