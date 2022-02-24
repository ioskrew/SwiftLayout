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
    
    public init(_ object: AnyObject) {
        self.object = object
        self.identifieds = MirrorDigger().dig(Mirror(reflecting: object))
    }
    
    public func update() {
        for identified in identifieds {
            identified.prepare()
        }
    }
    
    struct Identified: Hashable {
        let identifier: String
        let view: UIView
        
        init?(_ child: (String?, Any)) {
            guard let identifier = child.0 else { return nil }
            guard let view = child.1 as? UIView else { return nil }
            self.identifier = identifier.replacingOccurrences(of: "$__lazy_storage_$_", with: "")
            self.view = view
        }
        
        func prepare() {
            view.accessibilityIdentifier = identifier
        }
    }
    
    struct MirrorDigger {
        func dig(_ mirror: Mirror?) -> [Identified] {
            guard let mirror = mirror else {
                return []
            }
            return mirror.children.compactMap(Identified.init) + dig(mirror.superclassMirror)
        }
    }
}
