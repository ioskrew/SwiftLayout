//
//  UIView+Config.swift
//  
//
//  Created by oozoofrog on 2022/02/23.
//

import Foundation
import UIKit

public protocol SwiftLayoutViewConfiguration {
    func config(_ config: (Self) -> Self) -> Self
}

extension SwiftLayoutViewConfiguration where Self: UIView {
    public func config(_ config: (Self) -> Self) -> Self {
        return config(self)
    }
}

extension UIView: SwiftLayoutViewConfiguration {}
