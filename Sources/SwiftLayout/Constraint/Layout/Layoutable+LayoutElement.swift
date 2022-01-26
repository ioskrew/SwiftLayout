//
//  Constraint+Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/25.
//

import Foundation
import UIKit

protocol ElementLayoutable: Layoutable {}

extension SwiftLayout.Element: ElementLayoutable {
    public func isEqualLayout(_ layoutable: Layoutable) -> Bool {
        return self == layoutable as? Self
    }
    
    public func isEqualView(_ layoutable: Layoutable) -> Bool {
        return false
    }
    
    public func isEqualView(_ view: UIView?) -> Bool {
        self.view == view
    }
    
    public var layoutIdentifier: String {
        "Element.\(item.debugDescription).\(attribute)"
    }
    
    func find(secondElement element: SwiftLayout.Element) -> [NSLayoutConstraint] {
        guard let view = self.view else { return [] }
        return view.find(attribute: self.attribute, secondElement: element)
    }
}
