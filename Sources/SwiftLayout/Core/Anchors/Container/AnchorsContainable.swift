//
//  AnchorsContainable.swift
//  
//
//  Created by aiden_h on 2022/03/30.
//

import UIKit

protocol AnchorsContainable {
    mutating func setMultiplier(_ multiplier: CGFloat)
    func nsLayoutConstraint(item fromItem: NSObject, toItem: NSObject?, viewDic: [String: UIView]) -> [NSLayoutConstraint]
    var descriptions: [String] { get }
}
