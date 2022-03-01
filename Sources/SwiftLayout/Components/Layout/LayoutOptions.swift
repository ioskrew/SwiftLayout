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
    
    ///
    /// may root view has properties of its subviews.
    /// This option assigns the property name of each view to the accessibility identifier of the view.
    @available(*, deprecated, message: "using updateIdentifiers(rootObject:) instead of this")
    public static var automaticIdentifierAssignment = LayoutOptions(rawValue: 1)
    
    public static var usingAnimation = LayoutOptions(rawValue: 1 << 1)
}
