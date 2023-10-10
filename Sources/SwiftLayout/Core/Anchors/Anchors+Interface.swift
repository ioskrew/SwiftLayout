//
//  Anchors+Interface.swift
//  

import UIKit

public extension Anchors {
    
    /// combination of **leading and trailing** anchors for superview
    ///
    /// - Parameter offset: plus constant at leading, minus constant at trailing. default value is 0.
    /// - Returns: superview.leading + constant(offset) and superview.trailing - constant(offset)
    @available(*, deprecated, renamed: "Anchors.horizontal.equalToSuper(inwardOffset:)")
    static func horizontal(offset: CGFloat = .zero) -> Anchors {
        return Anchors.leading.trailing.equalToSuper(inwardOffset: offset)
    }
    
    /// combination of **leading and trailing** anchors for item
    /// - Parameters:
    ///   - item: target of anchors
    ///   - offset: plus constant at leading, minus constant at trailing. default value is 0.
    /// - Returns: item.leading + constant(offset) and item.trailing - constant(offset)
    @available(*, deprecated, renamed: "Anchors.horizontal.equalTo(_:inwardOffset:)")
    static func horizontal<I>(_ item: I, offset: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        return Anchors.leading.trailing.equalTo(item, inwardOffset: offset)
    }
    
    /// combination of **top and bottom** anchors for superview
    ///
    /// - Parameter offset: plus constant at top, minus constant at bottom. default value is 0.
    /// - Returns: superview.leading + constant(offset) and superview.trailing - constant(offset)
    @available(*, deprecated, renamed: "Anchors.vertical.equalToSuper(inwardOffset:)")
    static func vertical(offset: CGFloat = .zero) -> Anchors {
        return Anchors.top.bottom.equalToSuper(inwardOffset: offset)
    }
    
    /// combination of **top and bottom** anchors for item
    /// - Parameters:
    ///   - item: target of anchors
    ///   - offset: plus constant at top, minus constant at bottom. default value is 0.
    /// - Returns: item.top + constant(offset) and item.bottom - constant(offset)
    @available(*, deprecated, renamed: "Anchors.vertical.equalTo(_:inwardOffset:)")
    static func vertical<I>(_ item: I, offset: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        return Anchors.top.bottom.equalTo(item, inwardOffset: offset)
    }

    /// combination of **top, bottom, leading, trailing** anchors for superview
    ///
    /// - Parameter offset: plus constant at top, minus constant at bottom, plus constant at leading, minus constant at trailing. default value is 0.
    /// - Returns:
    /// superview.top + constant(offset) and superview.bottom - constant(offset)
    /// **AND**
    /// superview.leading + constant(offset) and superview.trailing - constant(offset)
    @available(*, deprecated, renamed: "Anchors.allSides.equalToSuper(inwardOffset:)")
    static func allSides(offset: CGFloat = .zero) -> Anchors {
        return Anchors.top.bottom.leading.trailing.equalToSuper(inwardOffset: offset)
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
    @available(*, deprecated, renamed: "Anchors.allSides.equalTo(_:inwardOffset:)")
    static func allSides<I>(_ item: I, offset: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        return Anchors.top.bottom.leading.trailing.equalTo(item, inwardOffset: offset)
    }

    /// combination of **top, leading, trailing** anchors for superview
    ///
    /// - Parameter offset: plus constant at top, plus constant at leading, minus constant at trailing. default value is 0.
    /// - Returns:
    /// superview.top + constant(offset)
    /// **AND**
    /// superview.leading + constant(offset) and superview.trailing - constant(offset)
    @available(*, deprecated, renamed: "Anchors.cap.equalToSuper(inwardOffset:)")
    static func cap(offset: CGFloat = .zero) -> Anchors {
        return Anchors.top.leading.trailing.equalToSuper(inwardOffset: offset)
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
    @available(*, deprecated, renamed: "Anchors.cap.equalTo(_:inwardOffset:)")
    static func cap<I>(_ item: I, offset: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        return Anchors.top.leading.trailing.equalTo(item, inwardOffset: offset)
    }

    /// combination of **bottom, leading, trailing** anchors for superview
    ///
    /// - Parameter offset: minus constant at bottom, plus constant at leading, minus constant at trailing. default value is 0.
    /// - Returns:
    /// superview.bottom - constant(offset)
    /// **AND**
    /// superview.leading + constant(offset) and superview.trailing - constant(offset)
    @available(*, deprecated, renamed: "Anchors.shoe.equalToSuper(inwardOffset:)")
    static func shoe(offset: CGFloat = .zero) -> Anchors {
        return Anchors.bottom.leading.trailing.equalToSuper(inwardOffset: offset)
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
    @available(*, deprecated, renamed: "Anchors.shoe.equalTo(_:inwardOffset:)")
    static func shoe<I>(_ item: I, offset: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        return Anchors.bottom.leading.trailing.equalTo(item, inwardOffset: offset)
    }

    /// dimensional combination of **width and height** anchors for selfview
    /// - Parameters:
    ///   - size: size of self
    /// - Returns: self.width = size.width and self.height = size.height
    @available(*, deprecated, renamed: "Anchors.size.equalTo(_:)")
    static func size(_ size: CGSize) -> Anchors {
        @AnchorsBuilder
        var anchors: Anchors {
            Anchors.width.equalTo(constant: size.width)
            Anchors.height.equalTo(constant: size.height)
        }
        return anchors
    }
    
    /// dimensional combination of **width and height** anchors for selfview
    /// - Parameters:
    ///   - width: width of self
    ///   - height: height of self
    /// - Returns: self.width = width and self.height = height
    @available(*, deprecated, renamed: "Anchors.size.equalTo(width:height:)")
    static func size(width: CGFloat, height: CGFloat) -> Anchors {
        @AnchorsBuilder
        var anchors: Anchors {
            Anchors.width.equalTo(constant: width)
            Anchors.height.equalTo(constant: height)
        }
        return anchors
    }
    
    /// dimensional combination of **width and height** anchors for selfview
    /// - Parameters:
    ///   - item: target of anchors
    ///   - width: width for target's + width
    ///   - height: height for target's + height
    /// - Returns: self.width = item.width + width and self.height = item.height + height
    @available(*, deprecated, renamed: "Anchors.size.equalTo(_:widthOffset:heightOffset:)")
    static func size<I>(_ item: I, width: CGFloat, height: CGFloat) -> Anchors where I: AnchorsItemable {
        @AnchorsBuilder
        var anchors: Anchors {
            Anchors.width.equalTo(item, constant: width)
            Anchors.height.equalTo(item, constant: height)
        }
        return anchors
    }
    
    /// positional combination of **center x, center y** anchors for superview
    /// - Parameters:
    ///   - offsetX: offset for x position from center of superview. default value is 0.
    ///   - offsetY: offset for y position from center of superview. default value is 0.
    /// - Returns: superview.centerX + offsetX and superview.centerY + offsetY
    @available(*, deprecated, renamed: "Anchors.center.equalToSuper(xOffset:yOffset:)")
    static func center(offsetX: CGFloat = .zero, offsetY: CGFloat = .zero) -> Anchors {
        @AnchorsBuilder
        var anchors: Anchors {
            Anchors.centerX.equalToSuper(constant: offsetX)
            Anchors.centerY.equalToSuper(constant: offsetY)
        }
        return anchors
    }
    
    /// positional combination of **center x, center y** anchors for superview
    /// - Parameters:
    ///   - item: target for anchors
    ///   - offsetX: offset for x position from center of target. default value is 0.
    ///   - offsetY: offset for y position from center of target. default value is 0.
    /// - Returns: item.centerX + offsetX and item.centerY + offsetY
    @available(*, deprecated, renamed: "Anchors.center.equalTo(_:xOffset:yOffset:)")
    static func center<I>(_ item: I, offsetX: CGFloat = .zero, offsetY: CGFloat = .zero) -> Anchors where I: AnchorsItemable {
        @AnchorsBuilder
        var anchors: Anchors {
            Anchors.centerX.equalTo(item, constant: offsetX)
            Anchors.centerY.equalTo(item, constant: offsetY)
        }
        return anchors
    }
}
