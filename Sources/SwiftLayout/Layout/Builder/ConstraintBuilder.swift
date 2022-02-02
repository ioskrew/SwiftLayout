//
//  ConstraintBuilder.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

@resultBuilder
public struct ConstraintBuilder {
    public static func buildBlock<C>(_ components: C...) -> [C] where C: Constraint {
        components
    }
}
