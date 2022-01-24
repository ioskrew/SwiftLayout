//
//  Constraint+Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/25.
//

import Foundation
import UIKit

extension SwiftLayout.Constraint: Layoutable {
    public func isEqualLayout(_ layoutable: Layoutable) -> Bool {
        isEqualView(layoutable)
    }
    
    public func isEqualView(_ layoutable: Layoutable) -> Bool {
        guard let constraint = layoutable as? SwiftLayout.Constraint else { return false }
        guard isEqualView(constraint.view) else { return false }
        return attribute == constraint.attribute
    }
    
    public func isEqualView(_ view: UIView?) -> Bool {
        self.view == view
    }
    
    public var layoutIdentifier: String {
        return attribute.debugDescription + ":" + view.layoutIdentifier
    }
    
    public var layoutIdentifierWithType: String {
        return attribute.debugDescription + ":" + view.layoutIdentifierWithType
    }
    
    public var debugDescription: String {
        layoutIdentifierWithType
    }
    
}
