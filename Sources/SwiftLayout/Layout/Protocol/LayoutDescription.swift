//
//  LayoutDescription.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol LayoutDescription {
    
    var layoutDescription: String { get }
    
}

extension LayoutDescription where Self: NSLayoutConstraint {
    public var layoutDescription: String {
        var descriptions: [String] = []
        if let item = firstItem as? UIView {
            descriptions.append(item.tagDescription)
            descriptions.append(".\(firstAttribute)")
        }
        descriptions.append(relation.description)
        if let item = secondItem as? UIView {
            descriptions.append(item.tagDescription)
            descriptions.append(".\(secondAttribute)")
        }
        return descriptions.joined(separator: " ")
    }
}

extension NSLayoutConstraint: LayoutDescription {}

extension LayoutDescription where Self: Collection, Self.Element == NSLayoutConstraint {
    public var layoutDescription: String {
        map(\.layoutDescription).joined(separator: ",\n")
    }
}

extension Array: LayoutDescription where Element == NSLayoutConstraint {}
