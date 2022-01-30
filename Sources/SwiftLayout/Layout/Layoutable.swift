//
//  Layoutable.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

public protocol Layoutable {
    @discardableResult
    func active() -> AnyLayoutable
    func deactive()
    func layoutTree(in parent: UIView) -> LayoutTree
    
    var equation: AnyHashable { get }
}

extension Layoutable {
    public func deactive() {}
}
