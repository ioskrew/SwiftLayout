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
    func active() -> Layoutable
    func layoutTree(in parent: UIView) -> LayoutTree
}
