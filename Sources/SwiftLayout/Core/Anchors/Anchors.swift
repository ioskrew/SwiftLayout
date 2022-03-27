//
//  Anchors.swift
//  
//
//  Created by aiden_h on 2022/03/27.
//

import UIKit

public enum Anchors {
    public static var centerX: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .centerX) }
    public static var leading: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .leading) }
    public static var left: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .left) }
    public static var right: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .right) }
    public static var trailing: AnchorsExpression<AnchorsXAxisAttribute> { AnchorsExpression(xAxis: .trailing) }
    public static var centerY: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .centerY) }
    public static var firstBaseline: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .firstBaseline) }
    public static var lastBaseline: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .lastBaseline) }
    public static var top: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .top) }
    public static var bottom: AnchorsExpression<AnchorsYAxisAttribute> { AnchorsExpression(yAxis: .bottom) }
    public static var height: AnchorsExpression<AnchorsDimensionAttribute> { AnchorsExpression(dimensions: .height) }
    public static var width: AnchorsExpression<AnchorsDimensionAttribute> { AnchorsExpression(dimensions: .width) }
    
    public static func xAxis(_ attributes: AnchorsXAxisAttribute...) -> AnchorsExpression<AnchorsXAxisAttribute> {
        AnchorsExpression(xAxis: attributes)
    }
    
    public static func yAxis(_ attributes: AnchorsYAxisAttribute...) -> AnchorsExpression<AnchorsYAxisAttribute> {
        return AnchorsExpression(yAxis: attributes)
    }
    
    public static func dimensions(_ attributes: AnchorsDimensionAttribute...) -> AnchorsExpression<AnchorsDimensionAttribute> {
        AnchorsExpression(dimensions: attributes)
    }
    
    public static func horizontal(offset: CGFloat = .zero) -> AnchorsContainer {
        let container = AnchorsContainer()
        container.append(AnchorsExpression(xAxis: .leading).equalToSuper(constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalToSuper(constant: -1.0 * offset))
        return container
    }
    
    public static func horizontal<I>(_ item: I, offset: CGFloat = .zero) -> AnchorsContainer where I: ConstraintableItem {
        let container = AnchorsContainer()
        container.append(AnchorsExpression(xAxis: .leading).equalTo(item, constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalTo(item, constant: -1.0 * offset))
        return container
    }
    
    public static func vertical(offset: CGFloat = .zero) -> AnchorsContainer {
        let container = AnchorsContainer()
        container.append(AnchorsExpression(yAxis: .top).equalToSuper(constant: offset))
        container.append(AnchorsExpression(yAxis: .bottom).equalToSuper(constant: -1.0 * offset))
        return container
    }
    
    public static func vertical<I>(_ item: I, offset: CGFloat = .zero) -> AnchorsContainer where I: ConstraintableItem {
        let container = AnchorsContainer()
        container.append(AnchorsExpression(yAxis: .top).equalTo(item, constant: offset))
        container.append(AnchorsExpression(yAxis: .bottom).equalTo(item, constant: -1.0 * offset))
        return container
    }
    
    public static func allSides(offset: CGFloat = .zero) -> AnchorsContainer {
        let container = AnchorsContainer()
        container.append(AnchorsExpression(yAxis: .top).equalToSuper(constant: offset))
        container.append(AnchorsExpression(yAxis: .bottom).equalToSuper(constant: -1.0 * offset))
        container.append(AnchorsExpression(xAxis: .leading).equalToSuper(constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalToSuper(constant: -1.0 * offset))
        return container
    }
    
    public static func allSides<I>(_ item: I, offset: CGFloat = .zero) -> AnchorsContainer where I: ConstraintableItem {
        let container = AnchorsContainer()
        container.append(AnchorsExpression(yAxis: .top).equalTo(item, constant: offset))
        container.append(AnchorsExpression(yAxis: .bottom).equalTo(item, constant: -1.0 * offset))
        container.append(AnchorsExpression(xAxis: .leading).equalTo(item, constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalTo(item, constant: -1.0 * offset))
        return container
    }
    
    public static func cap(offset: CGFloat = .zero) -> AnchorsContainer {
        let container = AnchorsContainer()
        container.append(AnchorsExpression(yAxis: .top).equalToSuper(constant: offset))
        container.append(AnchorsExpression(xAxis: .leading).equalToSuper(constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalToSuper(constant: -1.0 * offset))
        return container
    }
    
    public static func cap<I>(_ item: I, offset: CGFloat = .zero) -> AnchorsContainer where I: ConstraintableItem {
        let container = AnchorsContainer()
        container.append(AnchorsExpression(yAxis: .top).equalTo(item, constant: offset))
        container.append(AnchorsExpression(xAxis: .leading).equalTo(item, constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalTo(item, constant: -1.0 * offset))
        return container
    }
    
    public static func shoe(offset: CGFloat = .zero) -> AnchorsContainer {
        let container = AnchorsContainer()
        container.append(AnchorsExpression(yAxis: .bottom).equalToSuper(constant: -1.0 * offset))
        container.append(AnchorsExpression(xAxis: .leading).equalToSuper(constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalToSuper(constant: -1.0 * offset))
        return container
    }
    
    public static func shoe<I>(_ item: I, offset: CGFloat = .zero) -> AnchorsContainer where I: ConstraintableItem {
        let container = AnchorsContainer()
        container.append(AnchorsExpression(yAxis: .bottom).equalTo(item, constant: -1.0 * offset))
        container.append(AnchorsExpression(xAxis: .leading).equalTo(item, constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalTo(item, constant: -1.0 * offset))
        return container
    }
    
    public static func size(width: CGFloat, height: CGFloat) -> AnchorsContainer {
        let container = AnchorsContainer()
        container.append(AnchorsExpression(dimensions: .width).equalTo(constant: width))
        container.append(AnchorsExpression(dimensions: .height).equalTo(constant: height))
        return container
    }
    
    public static func size<I>(_ item: I, width: CGFloat, height: CGFloat) -> AnchorsContainer where I: ConstraintableItem {
        let container = AnchorsContainer()
        container.append(AnchorsExpression(dimensions: .width).equalTo(item, constant: width))
        container.append(AnchorsExpression(dimensions: .height).equalTo(item, constant: height))
        return container
    }
    
    public static func center(offsetX: CGFloat = .zero, offsetY: CGFloat = .zero) -> AnchorsContainer {
        let container = AnchorsContainer()
        container.append(AnchorsExpression(xAxis: .centerX).equalToSuper(constant: offsetX))
        container.append(AnchorsExpression(yAxis: .centerY).equalToSuper(constant: offsetY))
        return container
    }
    
    public static func center<I>(_ item: I, offsetX: CGFloat = .zero, offsetY: CGFloat = .zero) -> AnchorsContainer where I: ConstraintableItem {
        let container = AnchorsContainer()
        container.append(AnchorsExpression(xAxis: .centerX).equalTo(item, constant: offsetX))
        container.append(AnchorsExpression(yAxis: .centerY).equalTo(item, constant: offsetY))
        return container
    }
}


