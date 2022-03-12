//
//  Addressable.swift
//  
//
//  Created by oozoofrog on 2022/01/30.
//

import Foundation

struct TagDescriptor<Value>: CustomDebugStringConvertible where Value: TagDescriptable, Value: AnyObject {
    internal init(_ value: Value) {
        self.value = value
    }
    
    let value: Value
    
    var valueHasIdentifier: Bool {
        value.slAccessibilityIdentifier != nil
    }
    
    var identifier: String {
        if let identifier = value.slAccessibilityIdentifier, !identifier.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return identifier
        } else {
            return objectDescription
        }
    }
    
    var debugDescription: String {
        identifier
    }
    
    var objectDescription: String {
        AddressDescriptor(value).description
    }
    
}

protocol TagDescriptable {
    var slAccessibilityIdentifier: String? { get }
}

extension TagDescriptable where Self: SLView {
    var tagDescription: String {
        TagDescriptor(self).debugDescription
    }
}

extension TagDescriptable where Self: SLLayoutGuide {
    var tagDescription: String {
        TagDescriptor(self).debugDescription
    }
    
    var slAccessibilityIdentifier: String? { owningView?.slAccessibilityIdentifier }
}

extension SLView: TagDescriptable {}
extension SLLayoutGuide: TagDescriptable {}
