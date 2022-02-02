//
//  Constraint.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

public protocol Constraint {
    var constraints: [NSLayoutConstraint] { get }
}

extension Array: Constraint where Element: Constraint {
    public var constraints: [NSLayoutConstraint] {
        flatMap(\.constraints)
    }
}
