//
//  AnchorsBuilder.swift
//  

@resultBuilder
public struct AnchorsBuilder {
    public static func buildExpression<A>(_ expression: AnchorsExpression<A>) -> Anchors {
        Anchors(expression.constraintProperties())
    }

    public static func buildExpression<A>(_ expression: AnchorsExpression<A>?) -> Anchors {
        if let expression = expression {
            return Anchors(expression.constraintProperties())
        } else {
            return Anchors()
        }
    }

    public static func buildExpression(_ expression: AnchorsMixedExpression) -> Anchors {
        Anchors(expression.constraintProperties())
    }

    public static func buildExpression(_ expression: AnchorsMixedExpression?) -> Anchors {
        if let expression = expression {
            return Anchors(expression.constraintProperties())
        } else {
            return Anchors()
        }
    }
    
    public static func buildExpression(_ container: Anchors) -> Anchors {
        container
    }
    
    public static func buildExpression(_ container: Anchors?) -> Anchors {
        container ?? Anchors()
    }
}

extension AnchorsBuilder {
    public static func buildBlock(_ components: Anchors...) -> Anchors {
        components.reduce(into: Anchors()) { $0.append($1) }
    }
    
    public static func buildEither(first component: Anchors) -> Anchors {
        component
    }
    
    public static func buildEither(second component: Anchors) -> Anchors {
        component
    }

    public static func buildArray(_ components: [Anchors]) -> Anchors {
        components.reduce(into: Anchors()) { $0.append($1) }
    }

    public static func buildOptional(_ component: Anchors?) -> Anchors {
        component ?? Anchors()
    }
}
