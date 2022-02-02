//
//  Constraint.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

public protocol Constraint {
    func constraints(with view: UIView)
    func active() -> AnyDeactivatable
}

extension Constraint {
    public func active() -> AnyDeactivatable {
        .init()
    }
}

extension Array: Constraint where Element: Constraint {
    public func constraints(with view: UIView) {
        forEach({ constraint in
            constraint.constraints(with: view)
        })
    }
}
