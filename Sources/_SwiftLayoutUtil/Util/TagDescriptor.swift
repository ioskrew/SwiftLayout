//
//  Addressable.swift
//  
//
//  Created by oozoofrog on 2022/01/30.
//

import UIKit

struct TagDescriptor<Value>: CustomDebugStringConvertible where Value: TagDescriptable, Value: AnyObject {
    internal init(_ value: Value) {
        self.value = value
    }
    
    let value: Value
    
    var valueHasIdentifier: Bool {
        value.accessibilityIdentifier != nil
    }
    
    var identifier: String {
        if let identifier = value.accessibilityIdentifier, !identifier.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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

public protocol TagDescriptable {
    var accessibilityIdentifier: String? { get }
}

extension TagDescriptable where Self: UIView {
    public var tagDescription: String {
        TagDescriptor(self).debugDescription
    }
}

extension TagDescriptable where Self: UILayoutGuide {
    public var tagDescription: String {
        TagDescriptor(self).debugDescription
    }
    
    public var accessibilityIdentifier: String? { owningView?.accessibilityIdentifier }
}

extension UIView: TagDescriptable {}
extension UILayoutGuide: TagDescriptable {}
