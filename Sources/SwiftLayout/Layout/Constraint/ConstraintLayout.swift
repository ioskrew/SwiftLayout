//
//  ConstraintLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

public struct ConstraintLayout<V, C>: LayoutAttachable where V: UIView, C: Constraint {

    let view: V
    let constraints: C
    
    public func active() -> AnyDeactivatable {
        AnyDeactivatable()
    }
    
    public func deactive() {
        
    }
    
    public func attachLayout(_ layout: LayoutAttachable) {
        
    }
    
    public func constraints(with view: UIView) -> [NSLayoutConstraint] {
        []
    }
    
    public var hashable: AnyHashable {
        AnyHashable(0)
    }
    
    
}
