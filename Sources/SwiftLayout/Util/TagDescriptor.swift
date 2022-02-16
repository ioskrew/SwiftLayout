//
//  Addressable.swift
//  
//
//  Created by oozoofrog on 2022/01/30.
//

import Foundation
import UIKit

struct TagDescriptor<Value>: CustomDebugStringConvertible where Value: TagDescriptable, Value: AnyObject {
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
        "\(identifier):\(type(of: self.value))"
    }
    
}

protocol TagDescriptable {
    var accessibilityIdentifier: String? { get }
}

extension TagDescriptable where Self: UIView {
    var tagDescription: String {
        TagDescriptor(self).debugDescription
    }
}

extension TagDescriptable where Self: UILayoutGuide {
    var tagDescription: String {
        TagDescriptor(self).debugDescription
    }
    
    var accessibilityIdentifier: String? { owningView?.accessibilityIdentifier }
}

extension UIView: TagDescriptable {}
extension UILayoutGuide: TagDescriptable {}
