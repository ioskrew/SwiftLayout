//
//  Anchors.swift
//  
//
//  Created by aiden_h on 2022/03/27.
//

import UIKit

@MainActor
public final class Anchors {

    public private(set) var constraints: [AnchorsConstraintProperty]

    init(_ constraints: [AnchorsConstraintProperty] = []) {
        self.constraints = constraints
    }

    func append(_ container: Anchors) {
        self.constraints.append(contentsOf: container.constraints)
    }

    func constraints(item fromItem: NSObject, toItem: NSObject?, viewDic: [String: any HierarchyNode] = [:]) -> [NSLayoutConstraint] {
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

    public func priority(_ priority: UILayoutPriority) -> Self {
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
    static var centerXWithinMargins: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .centerXWithinMargins) }
    static var leftMargin: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .leftMargin) }
    static var rightMargin: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .rightMargin) }
    static var leadingMargin: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .leadingMargin) }
    static var trailingMargin: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .trailingMargin) }
    static var centerY: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .centerY) }
    static var top: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .top) }
    static var bottom: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .bottom) }
    static var firstBaseline: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .firstBaseline) }
    static var lastBaseline: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .lastBaseline) }
    static var centerYWithinMargins: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .centerYWithinMargins) }
    static var topMargin: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .topMargin) }
    static var bottomMargin: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .bottomMargin) }
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
