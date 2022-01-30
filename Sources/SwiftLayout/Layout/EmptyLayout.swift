//
//  EmptyLayout.swift
//  
//
//  Created by maylee on 2022/01/30.
//

import Foundation
import UIKit

struct EmptyLayout: Layoutable {
    func active() -> Layoutable {
        self
    }
    func layoutTree(in parent: UIView) -> LayoutTree {
        LayoutTree(view: parent, subtree: [])
    }
}
