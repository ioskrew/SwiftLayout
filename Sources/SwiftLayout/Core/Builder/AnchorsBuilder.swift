//
//  AnchorsBuilder.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

@resultBuilder
public struct AnchorsBuilder {
    public static func buildExpression<A>(_ anchors: AnchorsExpression<A>) -> AnchorsContainer {
        AnchorsContainer(anchors)
    }
    
    public static func buildExpression<A>(_ anchors: AnchorsExpression<A>?) -> AnchorsContainer {
        if let anchors = anchors {
            return AnchorsContainer(anchors)
        } else {
            return AnchorsContainer()
        }
    }
    
    public static func buildExpression(_ container: AnchorsContainer) -> AnchorsContainer {
        container
    }
    
    public static func buildExpression(_ container: AnchorsContainer?) -> AnchorsContainer {
        container ?? AnchorsContainer()
    }
}

extension AnchorsBuilder {
    public static func buildBlock(_ components: AnchorsContainer...) -> AnchorsContainer {
        components.reduce(into: AnchorsContainer()) { $0.append($1) }
    }
    
    public static func buildEither(first component: AnchorsContainer) -> AnchorsContainer {
        component
    }
    
    public static func buildEither(second component: AnchorsContainer) -> AnchorsContainer {
        component
    }

    public static func buildArray(_ components: [AnchorsContainer]) -> AnchorsContainer {
        components.reduce(into: AnchorsContainer()) { $0.append($1) }
    }
    
    public static func buildOptional(_ component: AnchorsContainer?) -> AnchorsContainer {
        component ?? AnchorsContainer()
    }
}
