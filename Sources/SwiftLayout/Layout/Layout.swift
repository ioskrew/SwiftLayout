//
//  Layoutable.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

public protocol Layout {
    @discardableResult
    func active() -> AnyLayout
    func deactive()
    func layoutTree(in parent: UIView) -> LayoutTree
    
    var equation: AnyHashable { get }
}

extension Layout {
    
    public func active() -> AnyLayout {
        AnyLayout(self)
    }
    
    public func deactive() {}
}
