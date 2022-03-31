//
//  ViewPrinter.swift
//
//
//  Created by oozoofrog on 2022/02/16.
//

import UIKit

public struct ViewPrinter: CustomStringConvertible {
    
    public struct PrintOptions: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        /// print system constraints
        public static let withSystemConstraints = PrintOptions(rawValue: 1)
        /// print view only have accessibility identifier
        public static let onlyIdentifier = PrintOptions(rawValue: 1 << 1)
        /// print with view config
        public static let withViewConfig = PrintOptions(rawValue: 1 << 2)
        /// print with short formatted
        public static let shortForm = PrintOptions(rawValue: 1 << 3)
    }
    
    public init(_ view: UIView, tags: [UIView: String] = [:], options: PrintOptions = []) {
        self.view = view
        let customTags = Dictionary(uniqueKeysWithValues: tags.map({ (AddressDescriptor($0.key), $0.value) }))
        self.viewTags = ViewTags.viewTagsFromView(view, customTags: customTags)
        self.options = options
    }
    
    private init(_ view: UIView, viewTages: ViewTags, options: PrintOptions) {
        self.view = view
        self.viewTags = viewTages
        self.options = options
    }
    
    let view: UIView
    let viewTags: ViewTags
    let options: PrintOptions
    
    public var description: String {
        guard let viewToken = ViewToken.Parser.from(view, viewTags: viewTags, options: options) else { return "" }
        let constraints = AnchorToken.Parser.from(view, viewTags: viewTags, options: options)
        return Describer(viewToken, constraints).description
    }
    
    /// print ``SwiftLayout`` syntax from view structures
    public func print() {
        Swift.print(description)
    }
    
    public func copyToPasteboard() {
        UIPasteboard.general.string = self.description
    }
    
    ///
    /// Set the **accessibilityIdentifier** of all view objects included in the layout hierarchy to the property name of the object that has each views.
    ///
    /// - Parameter rootObject: root object for referencing property names
    /// - Returns: The view itself with the **accessibilityIdentifier** applied
    ///
    @discardableResult
    public func updateIdentifiers<RO>(_ updater: IdentifierUpdater = .nameOnly, rootObject: RO?) -> Self {
        if let rootObject = rootObject {
            let viewTags = updater.update(rootObject, viewTags: self.viewTags)
            return Self.init(self.view, viewTages: viewTags, options: self.options)
        } else {
            return updateIdentifiers()
        }
    }
    
    ///
    /// Set the **accessibilityIdentifier** of all view objects included in the layout hierarchy to the property name of the object that has each views.
    ///
    /// - Parameter rootObject: root object for referencing property names
    /// - Returns: The view itself with the **accessibilityIdentifier** applied
    ///
    @discardableResult
    public func updateIdentifiers(_ updater: IdentifierUpdater = .nameOnly) -> Self {
        let viewTags = updater.update(self.view, viewTags: self.viewTags)
        return Self.init(self.view, viewTages: viewTags, options: self.options)
    }
}
