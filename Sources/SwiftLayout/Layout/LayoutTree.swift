//
//  LayoutTree.swift
//  
//
//  Created by oozoofrog on 2022/01/30.
//

import Foundation
import UIKit

struct LayoutTree: Layoutable {
    
    let view: UIView
    let subtree: [LayoutTree]
    
}
