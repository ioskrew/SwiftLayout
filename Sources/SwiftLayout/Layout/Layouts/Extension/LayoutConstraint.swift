//
//  ConstraintLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

public struct LayoutConstraint<Layoutable, Constraintable>: LayoutConstraintAttachable where Layoutable: Layout, Constraintable: LayoutConstraintAttachable {
    
    public var guide: UILayoutGuide? {
        constraint.guide
    }
    public var view: UIView? {
        constraint.view
    }
    
    let layout: Layoutable
    let constraint: Constraintable
    
    public func active() -> AnyDeactivatable {
        return layout.active()
    }
    
    public func deactive() {
        
    }
    
    public func constraints(with view: UIView) -> NSLayoutConstraint? {
        constraint.constraints(with: view)
    }
    
    public func attachLayout(_ layout: LayoutAttachable) {
        
    }
    
    public var hashable: AnyHashable {
        AnyHashable(0)
    }
}
