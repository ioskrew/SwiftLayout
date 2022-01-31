//
//  PairLayout.swift
//  
//
//  Created by oozoofrog on 2022/01/31.
//

import Foundation
import UIKit

public struct PairLayout<Left, Right>: LayoutAttachable, LayoutContainable where Left: LayoutAttachable, Right: LayoutAttachable {
    
    let left: Left
    let right: Right
    
    public var layouts: [LayoutAttachable] { [left, right] }
    
    public var equation: AnyHashable {
        AnyHashable([left.equation, right.equation])
    }
    
}
