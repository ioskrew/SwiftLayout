//
//  AnchorsContainable.swift
//  
//
//  Created by aiden_h on 2022/03/30.
//

import UIKit

protocol AnchorsContainable {
    func nsLayoutConstraint(item fromItem: NSObject, toItem: NSObject?, viewDic: [String: UIView]) -> [NSLayoutConstraint]
    mutating func setMultiplier(_ multiplier: CGFloat)
    
    //  Support SwiftLayoutUtil
    func getConstraintProperties() -> [AnchorsConstraintProperty]
}

