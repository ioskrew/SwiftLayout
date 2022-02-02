//
//  Constraint.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

public protocol Constraint {
    func constraints(with view: UIView) -> [NSLayoutConstraint]
    func active() -> AnyDeactivatable
}

extension Constraint {
    public func active() -> AnyDeactivatable {
        .init()
    }
}

extension Array: Constraint where Element: Constraint {
    public func constraints(with view: UIView) -> [NSLayoutConstraint] {
        flatMap({ constraint in
            constraint.constraints(with: view)
        })
    }
}
