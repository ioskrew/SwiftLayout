//
//  LayoutOptions.swift
//  
//
//  Created by oozoofrog on 2022/02/17.
//

import Foundation

public final class LayoutOptions {
    
    public init(options: LayoutOptions.Options, objectForAccessibilityIdentifier: AnyObject? = nil) {
        self.options = options
        self.objectForAccessibilityIdentifier = objectForAccessibilityIdentifier
    }
    
    public struct Options: OptionSet {

        private(set) public var rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        ///
        /// may root view has properties of its subviews.
        /// This option assigns the property name of each view to the accessibility identifier of the view.
        public static var accessibilityIdentifiers = Options(rawValue: 1)
        public static var usingAnimation = Options(rawValue: 1 << 1)
    }
    
    let options: Options
    var objectForAccessibilityIdentifier: AnyObject?
    
    func contains(_ options: Options) -> Bool {
        options.contains(options)
    }
    
}

extension Optional where Wrapped == LayoutOptions {
    public func contains(_ options: LayoutOptions.Options) -> Bool {
        guard let opts = self?.options else { return false }
        return opts.contains(options)
    }
}
