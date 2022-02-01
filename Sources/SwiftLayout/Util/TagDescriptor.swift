//
//  Addressable.swift
//  
//
//  Created by oozoofrog on 2022/01/30.
//

import Foundation
import UIKit

struct TagDescriptor<Value>: CustomDebugStringConvertible where Value: UIAccessibilityIdentification {
    internal init(_ value: Value) {
        self.value = value
    }
    
    let value: Value
    
    var identifier: String {
        if let identifier = value.accessibilityIdentifier {
            return identifier
        } else {
            return Unmanaged<Value>.passUnretained(value).toOpaque().debugDescription
        }
    }
    
    var debugDescription: String {
        "\(type(of: self.value))(\(identifier))"
    }
    
}

protocol TagDescriptable: UIAccessibilityIdentification {}

extension TagDescriptable where Self: UIView {
    
    var tagDescriptor: TagDescriptor<Self> {
        TagDescriptor(self)
    }
    
    var tagDescription: String {
        TagDescriptor(self).debugDescription
    }
    
}

extension UIView: TagDescriptable {}
