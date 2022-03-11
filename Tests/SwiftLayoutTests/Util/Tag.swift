//
//  File.swift
//  
//
//  Created by aiden_h on 2022/02/18.
//

import SwiftLayout
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
typealias UIAccessibilityIdentification = NSAccessibilityProtocol
extension NSAccessibilityProtocol {
    var accessibilityIdentifier: String? {
        get { accessibilityIdentifier() }
        set { setAccessibilityIdentifier(newValue) }
    }
}
#endif

@dynamicMemberLookup
struct Tag<Taggable> where Taggable: UIAccessibilityIdentification {
    let taggable: Taggable
    
    subscript(dynamicMember tag: String) -> Taggable {
        taggable.accessibilityIdentifier = tag
        return taggable
    }
}

extension UIAccessibilityIdentification {
    var viewTag: Tag<Self> {
        Tag(taggable: self)
    }
}
