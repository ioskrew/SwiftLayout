//
//  Layoutable.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

public protocol Layoutable: CustomDebugStringConvertible {
    
    var branches: [Layoutable] { get }
    
    func isEqualLayout(_ layoutable: Layoutable) -> Bool
    func isEqualView(_ layoutable: Layoutable) -> Bool
    func isEqualView(_ view: UIView?) -> Bool
    
    var layoutIdentifier: String { get }
}

extension Layoutable {
    public var branches: [Layoutable] { [] }
}

extension Layoutable where Self: UIView {
    func find(attribute: NSLayoutConstraint.Attribute, secondElement element: SwiftLayout.Element) -> [NSLayoutConstraint] {
        constraints.filter { constraint in
            let binding = constraint.binding
            return binding.first.view == self && binding.first.attribute == attribute && binding.second == element
        }
    }
}
