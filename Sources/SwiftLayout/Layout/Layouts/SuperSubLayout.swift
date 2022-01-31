//
//  SuperSubLayout.swift
//  
//
//  Created by oozoofrog on 2022/01/31.
//

import Foundation
import UIKit

public struct SuperSubLayout<SuperView, Sub>: Layout where SuperView: UIView, Sub: Layout {
    
    let superview: SuperView
    let subLayout: Sub
    
    public func active() -> AnyLayout {
        AnyLayout(self)
    }
    
    public func layoutTree(in parent: UIView) -> LayoutTree {
        subLayout.layoutTree(in: superview)
    }
    
    public var equation: AnyHashable {
       AnyHashable(0)
    }
    
}
