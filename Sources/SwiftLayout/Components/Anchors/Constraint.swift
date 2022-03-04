//
//  Constraint.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import Foundation
import UIKit

public protocol Constraint {
    func constraints(item: NSObject, toItem: NSObject?, viewInfoSet: ViewInformationSet?) -> [NSLayoutConstraint]
    func constraints(item: NSObject, toItem: NSObject?) -> [NSLayoutConstraint]
}
