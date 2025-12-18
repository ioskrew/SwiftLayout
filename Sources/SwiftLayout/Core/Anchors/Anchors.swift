//
//  Anchors.swift
//
//
//  Created by aiden_h on 2022/03/27.
//

import SwiftLayoutPlatform

/// A class that represents a collection of Auto Layout constraint definitions.
///
/// `Anchors` provides a fluent API for defining NSLayoutConstraint properties declaratively.
/// Use the static properties to start building constraint expressions.
///
/// ## Overview
///
/// Access constraint attributes through static properties and chain them together:
///
/// ```swift
/// view.sl.anchors {
///     // Single attribute
///     Anchors.top.equalToSuper(constant: 16)
///
///     // Multiple attributes
///     Anchors.leading.trailing.equalToSuper()
///
///     // Composite shortcuts
///     Anchors.allSides.equalToSuper()      // top, bottom, leading, trailing
///     Anchors.center.equalToSuper()         // centerX, centerY
///     Anchors.size.equalTo(width: 100, height: 50)
/// }
/// ```
///
/// ## Available Attributes
///
/// ### Position (X-Axis)
/// - ``leading``, ``trailing``, ``left``, ``right``, ``centerX``
/// - ``horizontal`` (leading + trailing)
///
/// ### Position (Y-Axis)
/// - ``top``, ``bottom``, ``centerY``, ``firstBaseline``, ``lastBaseline``
/// - ``vertical`` (top + bottom)
///
/// ### Size
/// - ``width``, ``height``
/// - ``size`` (width + height)
///
/// ### Composite
/// - ``allSides`` (top, bottom, leading, trailing)
/// - ``cap`` (top, leading, trailing)
/// - ``shoe`` (bottom, leading, trailing)
/// - ``center`` (centerX, centerY)
///
/// ## Modifiers
///
/// Apply modifiers to customize constraints:
///
/// ```swift
/// Anchors.width.equalToSuper()
///     .multiplier(0.5)           // 50% of superview width
///     .priority(.defaultHigh)    // Set priority
///     .identifier("myConstraint") // For debugging/updates
/// ```
@MainActor
public final class Anchors {

    public private(set) var constraints: [AnchorsConstraintProperty]

    init(_ constraints: [AnchorsConstraintProperty] = []) {
        self.constraints = constraints
    }

    func append(_ container: Anchors) {
        self.constraints.append(contentsOf: container.constraints)
    }

    func constraints(item fromItem: NSObject, toItem: NSObject?, viewDic: [String: any HierarchyNodable] = [:]) -> [NSLayoutConstraint] {
        constraints.map {
            $0.nsLayoutConstraint(item: fromItem, toItem: toItem, viewDic: viewDic)
        }
    }

    public func multiplier(_ multiplier: CGFloat) -> Self {
        for i in 0..<constraints.count {
            constraints[i].multiplier = multiplier
        }
        return self
    }

    public func priority(_ priority: SLLayoutPriority) -> Self {
        for i in 0..<constraints.count {
            constraints[i].priority = priority
        }
        return self
    }

    public func identifier(_ identifier: String) -> Self {
        for i in 0..<constraints.count {
            constraints[i].identifier = identifier
        }
        return self
    }
}

// MARK: - Expressions
public extension Anchors {
    // Attribute base
    static var centerX: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .centerX) }
    static var leading: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .leading) }
    static var trailing: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .trailing) }
    static var left: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .left) }
    static var right: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .right) }
    #if canImport(UIKit)
    static var centerXWithinMargins: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .centerXWithinMargins) }
    static var leftMargin: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .leftMargin) }
    static var rightMargin: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .rightMargin) }
    static var leadingMargin: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .leadingMargin) }
    static var trailingMargin: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .trailingMargin) }
    #endif
    static var centerY: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .centerY) }
    static var top: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .top) }
    static var bottom: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .bottom) }
    static var firstBaseline: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .firstBaseline) }
    static var lastBaseline: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .lastBaseline) }
    #if canImport(UIKit)
    static var centerYWithinMargins: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .centerYWithinMargins) }
    static var topMargin: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .topMargin) }
    static var bottomMargin: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .bottomMargin) }
    #endif
    static var height: AnchorsExpression<AnchorsDimensionAttribute> { AnchorsExpression(dimensions: .height) }
    static var width: AnchorsExpression<AnchorsDimensionAttribute> { AnchorsExpression(dimensions: .width) }

    // Composite
    static var horizontal: AnchorsExpression<AnchorsXAxisAttribute> { Anchors.leading.trailing }
    static var vertical: AnchorsExpression<AnchorsYAxisAttribute> { Anchors.top.bottom }
    static var allSides: AnchorsMixedExpression { Anchors.top.bottom.leading.trailing }
    static var cap: AnchorsMixedExpression { Anchors.top.leading.trailing }
    static var shoe: AnchorsMixedExpression { Anchors.bottom.leading.trailing }

    static var size: AnchorsSizeExpression { AnchorsSizeExpression() }
    static var center: AnchorsCenterExpression { AnchorsCenterExpression() }
}
