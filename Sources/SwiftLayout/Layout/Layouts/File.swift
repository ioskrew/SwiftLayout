//
//  SuperSubLayout.swift
//  
//
//  Created by oozoofrog on 2022/01/31.
//

import Foundation
import UIKit

struct SuperSubLayout<Super, Sub>: Layout where Super: Layout, Sub: Layout {
    func active() -> AnyLayoutable {
        AnyLayoutable(self)
    }
    
    func layoutTree(in parent: UIView) -> LayoutTree {
        LayoutTree(view: .init())
    }
    
    var equation: AnyHashable {
       AnyHashable(0)
    }
    
}
