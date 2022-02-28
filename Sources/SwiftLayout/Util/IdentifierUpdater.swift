//
//  ObjectIdentifiers.swift
//  
//
//  Created by oozoofrog on 2022/02/17.
//

import Foundation
import UIKit

public struct IdentifierUpdater {
    
    let object: AnyObject
    let identifieds: [Identified]
    
    public var identifiersWithAddress: [String] {
        identifieds.map({ $0.identifier + ":" + AddressDescriptor($0.view).description })
    }
    
    public var identifiers: [String] {
        identifieds.map(\.identifier)
    }
    
    public init(_ object: AnyObject, prefix: String = "") {
        self.object = object
        self.identifieds = MirrorDigger().dig(Mirror(reflecting: object), prefix: prefix)
    }
    
    public func update() {
        for identified in identifieds {
            identified.prepare()
        }
    }
    
    final class Identified: Hashable {
        static func == (lhs: IdentifierUpdater.Identified, rhs: IdentifierUpdater.Identified) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
        
        internal init(prefix: String = "", identifier: String, view: UIView) {
            self.prefix = prefix
            self.identifier = identifier
            self.view = view
        }
        
        let prefix: String
        let identifier: String
        let view: UIView
        
        func prepare() {
            if prefix.isEmpty {
                view.accessibilityIdentifier = "\(identifier):\(type(of: view))"
            } else {
                view.accessibilityIdentifier = "\(prefix).\(identifier):\(type(of: view))"
            }
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(prefix)
            hasher.combine(identifier)
            hasher.combine(view)
        }
    }
    
    struct MirrorDigger {
        
        func identifier(prefix: String, identifier: String) -> String {
            if prefix.isEmpty {
                return identifier
            } else {
                return "\(prefix).\(identifier)"
            }
        }
        
        func dig(_ mirror: Mirror, prefix: String = "") -> [Identified] {
            var identifieds: [Identified] = []
            if let superclassMirror = mirror.superclassMirror {
                identifieds.append(contentsOf: dig(superclassMirror, prefix: prefix))
            }
            for child in mirror.children {
                guard let label = child.label?.replacingOccurrences(of: "$__lazy_storage_$_", with: "") else { continue }
                guard let view = child.value as? UIView else { continue }
                identifieds.append(Identified(prefix: prefix, identifier: label, view: view))
                identifieds.append(contentsOf: dig(Mirror(reflecting: view), prefix: identifier(prefix: prefix, identifier: label)))
            }
            return identifieds
        }
    }
}
