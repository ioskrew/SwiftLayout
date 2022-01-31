//
//  SuperSubLayout.swift
//  
//
//  Created by oozoofrog on 2022/01/31.
//

import Foundation
import UIKit

public struct SuperSubLayout<SuperView, Sub>: Layout where SuperView: UIView, Sub: Layout {
    
    let superview: SuperView
    let subLayout: Sub
    
    public var equation: AnyHashable {
        let superHash = superview.equation
        let subHash = subLayout.equation
        return AnyHashable([superHash, subHash])
    }
    
}
