//
//  ConstraintLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

public struct ConstraintLayout<C>: LayoutViewContainable where C: Constraint {

    public let view: UIView
    let constraint: C
    public var layouts: [Layout] = []
    
}
