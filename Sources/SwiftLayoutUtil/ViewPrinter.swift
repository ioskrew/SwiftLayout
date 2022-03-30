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
    
    public init(_ view: UIView, tags: [UIView: String] = [:]) {
        self.view = view
        let customTags = Dictionary(uniqueKeysWithValues: tags.map({ (AddressDescriptor($0.key), $0.value) }))
        self.viewTags = ViewTags.viewTagsFromView(view, customTags: customTags)
    }
    
    private init(_ view: UIView, viewTages: ViewTags) {
        self.view = view
        self.viewTags = viewTages
    }
    
    let view: UIView
    let viewTags: ViewTags
    
    public var description: String {
        print()
    }
    
    /// print ``SwiftLayout`` syntax from view structures
    /// - Parameters:
    ///  - updater: ``IdentifierUpdater``
    ///  - systemConstraintsHidden: automatically assigned constraints from system hidden, default value is `true`
    ///  - printOnlyIdentifier: print view only having accessibility identifier
    /// - Returns: String of SwiftLayout syntax
    @available(*, deprecated, message: "use PrintOptions")
    public func print(_ updater: IdentifierUpdater? = nil,
                      systemConstraintsHidden: Bool = true,
                      printOnlyIdentifier: Bool = false) -> String {
        var options: PrintOptions = []
        if !systemConstraintsHidden {
            options.insert(.withSystemConstraints)
        }
        if printOnlyIdentifier {
            options.insert(.onlyIdentifier)
        }
        return print(options: options)
    }
    
    /// print ``SwiftLayout`` syntax from view structures
    /// - Parameters:
    ///  - updater: ``IdentifierUpdater``
    ///  - options: ``PrintOptions``
    /// - Returns: String of SwiftLayout syntax
    public func print(options: PrintOptions = []) -> String {
        guard let viewToken = ViewToken.Parser.from(view, viewTags: viewTags, options: options) else { return "" }
        let constraints = AnchorToken.Parser.from(view, viewTags: viewTags, options: options)
        return Describer(viewToken, constraints).description
    }
    
    ///
    /// Set the **accessibilityIdentifier** of all view objects included in the layout hierarchy to the property name of the object that has each views.
    ///
    /// - Parameter rootObject: root object for referencing property names
    /// - Returns: The view itself with the **accessibilityIdentifier** applied
    ///
    @discardableResult
    public func updateIdentifiers(_ updater: IdentifierUpdater = .nameOnly, rootObject: AnyObject? = nil) -> Self {
        let viewTags = updater.update(rootObject ?? self.view, viewTags: self.viewTags)
        return Self.init(self.view, viewTages: viewTags)
    }
    
}
