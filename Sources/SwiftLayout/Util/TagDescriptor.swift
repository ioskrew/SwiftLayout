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
        value.slIdentifier != nil
    }
    
    var identifier: String {
        if let identifier = value.slIdentifier, !identifier.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
    var slIdentifier: String? { get }
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
    
    var slIdentifier: String? { owningView?.slIdentifier }
}

extension SLView: TagDescriptable {}
extension SLLayoutGuide: TagDescriptable {}
