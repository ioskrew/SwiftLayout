//
//  ObjectIdentifiers.swift
//  
//
//  Created by oozoofrog on 2022/02/17.
//

import Foundation

public final class IdentifierUpdater {
    /// update identifiers with property name
    public static var nameOnly: IdentifierUpdater { IdentifierUpdater(.nameOnly) }
    /// update identifier with property name and type of view
    public static var withTypeOfView: IdentifierUpdater { IdentifierUpdater(.withTypeOfView) }
    /// update identifier with references and property name
    public static var referenceAndName: IdentifierUpdater { IdentifierUpdater(.referenceAndName) }
    /// update identifier with references and property name with type of view
    public static var referenceAndNameWithTypeOfView: IdentifierUpdater { IdentifierUpdater(.referenceAndNameWithTypeOfView) }
    
    private let option: IdentifierUpdater.Option
    
    private init(_ option: IdentifierUpdater.Option) {
        self.option = option
    }
    
    public func update(_ target: Any, prefix: String = "", fixedTags: Set<String> = []) {
        let digger = MirrorDigger(enablePrefixChain: option == .referenceAndName || option == .referenceAndNameWithTypeOfView )
        digger.digging(Mirror(reflecting: target), prefix: prefix)
        for identified in digger.identifieds where !fixedTags.contains(TagDescriptor(identified.view).objectDescription) {
            identified.prepare(enableViewType: option == .withTypeOfView || option == .referenceAndNameWithTypeOfView)
        }
    }
    
    final class Identified: Hashable, CustomDebugStringConvertible {
        static func == (lhs: IdentifierUpdater.Identified, rhs: IdentifierUpdater.Identified) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
        
        internal init(prefix: String = "", identifier: String, view: SLView) {
            self.prefix = prefix
            self.identifier = identifier
            self.view = view
        }
        
        let prefix: String
        let identifier: String
        let view: SLView
        
        func prepare(enableViewType: Bool = false) {
            if enableViewType {
                if prefix.isEmpty {
                    view.slAccessibilityIdentifier = "\(identifier):\(type(of: view))"
                } else {
                    view.slAccessibilityIdentifier = "\(prefix).\(identifier):\(type(of: view))"
                }
            } else {
                
                if prefix.isEmpty {
                    view.slAccessibilityIdentifier = identifier
                } else {
                    view.slAccessibilityIdentifier = "\(prefix).\(identifier)"
                }
            }
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
            hasher.combine(view)
        }
        
        var debugDescription: String {
            if prefix.isEmpty {
                return "\(identifier):\(type(of: view))"
            } else {
                return "\(prefix).\(identifier):\(type(of: view))"
            }
        }
    }
    
    final class MirrorDigger {
        internal init(enablePrefixChain: Bool) {
            self.enablePrefixChain = enablePrefixChain
        }
        
        private(set) var identifieds: Set<Identified> = []
        
        let enablePrefixChain: Bool
        
        func digging(_ mirror: Mirror, prefix: String = "") {
            if let superclassMirror = mirror.superclassMirror {
                digging(superclassMirror, prefix: prefix)
            }
            for child in mirror.children {
                guard let label = child.label?.replacingOccurrences(of: "$__lazy_storage_$_", with: "") else { continue }
                guard let view = child.value as? SLView else { continue }
                let identified = Identified(prefix: enablePrefixChain ? prefix : "", identifier: label, view: view)
                if self.identifieds.contains(identified) { continue }
                self.identifieds.insert(identified)
                if enablePrefixChain {
                    digging(Mirror(reflecting: view), prefix: identifier(prefix: prefix, identifier: label))
                }
            }
        }
        
        func identifier(prefix: String, identifier: String) -> String {
            if prefix.isEmpty {
                return identifier
            } else {
                return "\(prefix).\(identifier)"
            }
        }
        
    }
    
    ///
    /// set accessibility identifier from property name
    ///
    private enum Option {
        case `none`
        /// set identifier with property name
        case nameOnly
        /// set identifier with property name and type of view
        case withTypeOfView
        /// set identifier with prefix of reference owner chains and property name
        case referenceAndName
        /// set identifier with prefix of reference owner chains and property name with type of view
        case referenceAndNameWithTypeOfView
    }
}
