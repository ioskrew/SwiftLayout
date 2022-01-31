//
//  PairLayout.swift
//  
//
//  Created by oozoofrog on 2022/01/31.
//

import Foundation
import UIKit

public struct PairLayout<Left, Right>: Layout where Left: Layout, Right: Layout {
    
    let left: Left
    let right: Right
    
    public var equation: AnyHashable {
        AnyHashable([left.equation, right.equation])
    }
    
}
