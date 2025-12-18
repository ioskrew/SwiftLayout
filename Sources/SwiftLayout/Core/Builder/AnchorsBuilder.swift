//
//  AnchorsBuilder.swift
//

/// A result builder for constructing Auto Layout constraints declaratively.
///
/// `AnchorsBuilder` enables the DSL syntax used within `.anchors { }` blocks
/// for defining layout constraints.
///
/// ## Overview
///
/// Use `AnchorsBuilder` within the `anchors` method to define constraints:
///
/// ```swift
/// view.sl.anchors {
///     Anchors.top.equalToSuper(constant: 16)
///     Anchors.leading.trailing.equalToSuper()
///     Anchors.height.equalTo(constant: 44)
/// }
/// ```
///
/// ## Supported Constructs
///
/// `AnchorsBuilder` supports conditionals and loops:
///
/// ```swift
/// view.sl.anchors {
///     Anchors.horizontal.equalToSuper()
///     if isCompact {
///         Anchors.height.equalTo(constant: 44)
///     } else {
///         Anchors.height.equalTo(constant: 88)
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Related Types
/// - ``Anchors``
/// - ``AnchorsExpression``
@MainActor
@resultBuilder
public struct AnchorsBuilder {
    public static func buildExpression<Omitable: AnchorsExpressionOmitable>(_ expression: Omitable) -> Anchors {
        expression.defaultExpression()
    }

    public static func buildExpression<Omitable: AnchorsExpressionOmitable>(_ expression: Omitable?) -> Anchors {
        expression?.defaultExpression() ?? Anchors()
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
