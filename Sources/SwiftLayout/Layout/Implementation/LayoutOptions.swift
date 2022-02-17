//
//  LayoutOptions.swift
//  
//
//  Created by oozoofrog on 2022/02/17.
//

import Foundation

public struct LayoutOptions: OptionSet {
    
    private(set) public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    @discardableResult
    public mutating func insert(_ newMember: LayoutOptions) -> (inserted: Bool, memberAfterInsert: LayoutOptions) {
        rawValue |= newMember.rawValue
        payload.objectForAccessibilityIdentifier = newMember.objectForAccessibilityIdentifier
        return (true, self)
    }
    
    private let payload = PayloadContainer()
    
    var objectForAccessibilityIdentifier: AnyObject? {
        payload.objectForAccessibilityIdentifier
    }
    
    ///
    /// may root view has properties of its subviews.
    /// This option assigns the property name of each view to the accessibility identifier of the view.
    public static var accessibilityIdentifiers: LayoutOptions { LayoutOptions(rawValue: 1) }
    public static func accessibilityIdentifiersInObject(_ object: AnyObject) -> LayoutOptions {
        let options = accessibilityIdentifiers
        options.payload.objectForAccessibilityIdentifier = object
        return options
    }
    public static var usingAnimation: LayoutOptions { LayoutOptions(rawValue: 1 << 1) }
    
    private final class PayloadContainer {
        weak var objectForAccessibilityIdentifier: AnyObject?
    }
}
