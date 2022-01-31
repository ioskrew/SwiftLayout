//
//  LayoutableComponents.swift
//  
//
//  Created by oozoofrog on 2022/01/29.
//

import Foundation
import UIKit

struct LayoutableComponents: Layout {
    let layoutables: [Layout]
    
    init(_ layoutables: [Layout]) {
        self.layoutables = layoutables
    }
    
    func active() -> AnyLayoutable {
        layoutables.forEach({ $0.active() })
        return AnyLayoutable(self)
    }
    
    func layoutTree(in parent: UIView) -> LayoutTree {
        LayoutTree(view: parent, subtree: layoutables.map({ $0.layoutTree(in: parent) }))
    }
    
    var equation: AnyHashable {
        AnyHashable(layoutables.map(\.equation))
    }
}
