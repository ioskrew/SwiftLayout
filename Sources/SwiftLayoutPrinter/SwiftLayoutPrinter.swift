//
//  SwiftLayoutPrinter.swift
//  
//
//  Created by oozoofrog on 2022/02/16.
//

import Foundation
import SwiftLayout
import UIKit

public struct SwiftLayoutPrinter: CustomStringConvertible {
    
    public struct PrintOptions: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        /// print system constraints
        public static let withSystemConstraints: PrintOptions = .init(rawValue: 1)
        /// print view only have accessibility identifier
        public static let onlyIdentifier: PrintOptions = .init(rawValue: 1 << 1)
        /// print with view config
        public static let withViewConfig: PrintOptions = .init(rawValue: 1 << 2)
    }
    
    public init(_ view: SLView, tags: [SLView: String] = [:]) {
        self.view = view
        self.tags = [:] // Dictionary(uniqueKeysWithValues: tags.map({ ($0.key.tagDescription, $0.value) }))
    }
    
    weak var view: SLView?
    let tags: [String: String]
    
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
        return print(updater, options: options)
    }
    
    /// print ``SwiftLayout`` syntax from view structures
    /// - Parameters:
    ///  - updater: ``IdentifierUpdater``
    ///  - options: ``PrintOptions``
    /// - Returns: String of SwiftLayout syntax
    public func print(_ updater: IdentifierUpdater? = nil, options: PrintOptions = []) -> String {
        return ""
    }
    
}

extension NSTextAlignment: CustomStringConvertible {
    public var description: String {
        switch self {
        case .center:       return "center"
        case .justified:    return "justified"
        case .left:         return "left"
        case .natural:      return "natural"
        case .right:        return "right"
        default:            return "unknown"
        }
    }
}

extension NSLineBreakMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .byTruncatingHead:     return "byTruncatingHead"
        case .byCharWrapping:       return "byCharWrapping"
        case .byClipping:           return "byClipping"
        case .byTruncatingMiddle:   return "byTruncatingMiddle"
        case .byTruncatingTail:     return "byTruncatingTail"
        case .byWordWrapping:       return "byWordWrapping"
        @unknown default:           return "unknown"
        }
    }
}
