//
//  Anchors+Interface.swift
//  
//
//  Created by aiden_h on 2022/03/27.
//

import UIKit

public extension Anchors {

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
    
    /// combination of **leading and trailing** anchors for superview
    ///
    /// - Parameter offset: plus constant at leading, minus constant at trailing. default value is 0.
    /// - Returns: superview.leading + constant(offset) and superview.trailing - constant(offset)
    static func horizontal(offset: CGFloat = .zero) -> Anchors {
        let container = Anchors()
        container.append(AnchorsExpression(xAxis: .leading).equalToSuper(constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalToSuper(constant: -1.0 * offset))
        return container
    }
    
    /// combination of **leading and trailing** anchors for item
    /// - Parameters:
    ///   - item: target of anchors
    ///   - offset: plus constant at leading, minus constant at trailing. default value is 0.
    /// - Returns: item.leading + constant(offset) and item.trailing - constant(offset)
    static func horizontal<I>(_ item: I, offset: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        let container = Anchors()
        container.append(AnchorsExpression(xAxis: .leading).equalTo(item, constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalTo(item, constant: -1.0 * offset))
        return container
    }
    
    /// combination of **top and bottom** anchors for superview
    ///
    /// - Parameter offset: plus constant at top, minus constant at bottom. default value is 0.
    /// - Returns: superview.leading + constant(offset) and superview.trailing - constant(offset)
    static func vertical(offset: CGFloat = .zero) -> Anchors {
        let container = Anchors()
        container.append(AnchorsExpression(yAxis: .top).equalToSuper(constant: offset))
        container.append(AnchorsExpression(yAxis: .bottom).equalToSuper(constant: -1.0 * offset))
        return container
    }
    
    /// combination of **top and bottom** anchors for item
    /// - Parameters:
    ///   - item: target of anchors
    ///   - offset: plus constant at top, minus constant at bottom. default value is 0.
    /// - Returns: item.top + constant(offset) and item.bottom - constant(offset)
    static func vertical<I>(_ item: I, offset: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        let container = Anchors()
        container.append(AnchorsExpression(yAxis: .top).equalTo(item, constant: offset))
        container.append(AnchorsExpression(yAxis: .bottom).equalTo(item, constant: -1.0 * offset))
        return container
    }
    
    /// combination of **top, bottom, leading, trailing** anchors for superview
    ///
    /// - Parameter offset: plus constant at top, minus constant at bottom, plus constant at leading, minus constant at trailing. default value is 0.
    /// - Returns:
    /// superview.top + constant(offset) and superview.bottom - constant(offset)
    /// **AND**
    /// superview.leading + constant(offset) and superview.trailing - constant(offset)
    static func allSides(offset: CGFloat = .zero) -> Anchors {
        let container = Anchors()
        container.append(AnchorsExpression(yAxis: .top).equalToSuper(constant: offset))
        container.append(AnchorsExpression(yAxis: .bottom).equalToSuper(constant: -1.0 * offset))
        container.append(AnchorsExpression(xAxis: .leading).equalToSuper(constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalToSuper(constant: -1.0 * offset))
        return container
    }
    
    /// combination of **top, bottom, leading, trailing** anchors for superview
    ///
    /// - Parameters:
    ///   - item: target of anchors
    ///   - offset: plus constant at top, minus constant at bottom, plus constant at leading, minus constant at trailing. default value is 0.
    /// - Returns:
    /// superview.top + constant(offset) and superview.bottom - constant(offset)
    /// **AND**
    /// superview.leading + constant(offset) and superview.trailing - constant(offset)
    static func allSides<I>(_ item: I, offset: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        let container = Anchors()
        container.append(AnchorsExpression(yAxis: .top).equalTo(item, constant: offset))
        container.append(AnchorsExpression(yAxis: .bottom).equalTo(item, constant: -1.0 * offset))
        container.append(AnchorsExpression(xAxis: .leading).equalTo(item, constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalTo(item, constant: -1.0 * offset))
        return container
    }
    
    /// combination of **top, leading, trailing** anchors for superview
    ///
    /// - Parameter offset: plus constant at top, plus constant at leading, minus constant at trailing. default value is 0.
    /// - Returns:
    /// superview.top + constant(offset)
    /// **AND**
    /// superview.leading + constant(offset) and superview.trailing - constant(offset)
    static func cap(offset: CGFloat = .zero) -> Anchors {
        let container = Anchors()
        container.append(AnchorsExpression(yAxis: .top).equalToSuper(constant: offset))
        container.append(AnchorsExpression(xAxis: .leading).equalToSuper(constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalToSuper(constant: -1.0 * offset))
        return container
    }
    
    /// combination of **top, leading, trailing** anchors for superview
    ///
    /// - Parameters:
    ///   - item: target of anchors
    ///   - offset: plus constant at top, plus constant at leading, minus constant at trailing. default value is 0.
    /// - Returns:
    /// superview.top + constant(offset)
    /// **AND**
    /// superview.leading + constant(offset) and superview.trailing - constant(offset)
    static func cap<I>(_ item: I, offset: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        let container = Anchors()
        container.append(AnchorsExpression(yAxis: .top).equalTo(item, constant: offset))
        container.append(AnchorsExpression(xAxis: .leading).equalTo(item, constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalTo(item, constant: -1.0 * offset))
        return container
    }
    
    /// combination of **bottom, leading, trailing** anchors for superview
    ///
    /// - Parameter offset: minus constant at bottom, plus constant at leading, minus constant at trailing. default value is 0.
    /// - Returns:
    /// superview.bottom - constant(offset)
    /// **AND**
    /// superview.leading + constant(offset) and superview.trailing - constant(offset)
    static func shoe(offset: CGFloat = .zero) -> Anchors {
        let container = Anchors()
        container.append(AnchorsExpression(yAxis: .bottom).equalToSuper(constant: -1.0 * offset))
        container.append(AnchorsExpression(xAxis: .leading).equalToSuper(constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalToSuper(constant: -1.0 * offset))
        return container
    }
    
    /// combination of **bottom, leading, trailing** anchors for superview
    ///
    /// - Parameters:
    ///   - item: target of anchors
    ///   - offset: minus constant at bottom, plus constant at leading, minus constant at trailing. default value is 0.
    /// - Returns:
    /// superview.minus - constant(offset)
    /// **AND**
    /// superview.leading + constant(offset) and superview.trailing - constant(offset)
    static func shoe<I>(_ item: I, offset: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        let container = Anchors()
        container.append(AnchorsExpression(yAxis: .bottom).equalTo(item, constant: -1.0 * offset))
        container.append(AnchorsExpression(xAxis: .leading).equalTo(item, constant: offset))
        container.append(AnchorsExpression(xAxis: .trailing).equalTo(item, constant: -1.0 * offset))
        return container
    }

    /// dimensional combination of **width and height** anchors for selfview
    /// - Parameters:
    ///   - size: size of self
    /// - Returns: self.width = size.width and self.height = size.height
    static func size(_ size: CGSize) -> Anchors {
        let container = Anchors()
        container.append(AnchorsExpression(dimensions: .width).equalTo(constant: size.width))
        container.append(AnchorsExpression(dimensions: .height).equalTo(constant: size.height))
        return container
    }
    
    /// dimensional combination of **width and height** anchors for selfview
    /// - Parameters:
    ///   - width: width of self
    ///   - height: height of self
    /// - Returns: self.width = width and self.height = height
    static func size(width: CGFloat, height: CGFloat) -> Anchors {
        let container = Anchors()
        container.append(AnchorsExpression(dimensions: .width).equalTo(constant: width))
        container.append(AnchorsExpression(dimensions: .height).equalTo(constant: height))
        return container
    }
    
    /// dimensional combination of **width and height** anchors for selfview
    /// - Parameters:
    ///   - item: target of anchors
    ///   - width: width for target's + width
    ///   - height: height for target's + height
    /// - Returns: self.width = item.width + width and self.height = item.height + height
    static func size<I>(_ item: I, width: CGFloat, height: CGFloat) -> Anchors where I: AnchorsItemable {
        let container = Anchors()
        container.append(AnchorsExpression(dimensions: .width).equalTo(item, constant: width))
        container.append(AnchorsExpression(dimensions: .height).equalTo(item, constant: height))
        return container
    }
    
    /// positional combination of **center x, center y** anchors for superview
    /// - Parameters:
    ///   - offsetX: offset for x position from center of superview. default value is 0.
    ///   - offsetY: offset for y position from center of superview. default value is 0.
    /// - Returns: superview.centerX + offsetX and superview.centerY + offsetY
    static func center(offsetX: CGFloat = .zero, offsetY: CGFloat = .zero) -> Anchors {
        let container = Anchors()
        container.append(AnchorsExpression(xAxis: .centerX).equalToSuper(constant: offsetX))
        container.append(AnchorsExpression(yAxis: .centerY).equalToSuper(constant: offsetY))
        return container
    }
    
    /// positional combination of **center x, center y** anchors for superview
    /// - Parameters:
    ///   - item: target for anchors
    ///   - offsetX: offset for x position from center of target. default value is 0.
    ///   - offsetY: offset for y position from center of target. default value is 0.
    /// - Returns: item.centerX + offsetX and item.centerY + offsetY
    static func center<I>(_ item: I, offsetX: CGFloat = .zero, offsetY: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        let container = Anchors()
        container.append(AnchorsExpression(xAxis: .centerX).equalTo(item, constant: offsetX))
        container.append(AnchorsExpression(yAxis: .centerY).equalTo(item, constant: offsetY))
        return container
    }
}


