//
//  EmptyLayout.swift
//  
//
//  Created by maylee on 2022/01/30.
//

import Foundation
import UIKit

struct EmptyLayout: Layout {
    func active() -> AnyLayout {
        AnyLayout(nil)
    }
    
    func layoutTree(in parent: UIView) -> LayoutTree {
        LayoutTree(view: parent, subtree: [])
    }
    
    var equation: AnyHashable {
        AnyHashable(0)
    }
}
