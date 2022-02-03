//
//  NSLayoutAnchor+Layout.swift
//  
//
//  Created by oozoofrog on 2022/02/03.
//

import Foundation
import UIKit

extension NSLayoutAnchor: LayoutAttachable {}

extension Layout where Self: NSLayoutAnchorConstraint {
    public func deactive() {
        
    }
    
    public func attachConstraint(_ constraint: Constraint) {
        
    }
    
    public func attachLayout(_ layout: LayoutAttachable) {
        
    }
    
    public var hashable: AnyHashable {
        AnyHashable(0)
    }
}
