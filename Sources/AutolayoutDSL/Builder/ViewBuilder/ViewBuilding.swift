//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

public protocol ViewBuilding {
    var views: [UIView] { get }
}

extension UIView: ViewBuilding {
    public var views: [UIView] { [self] }
}
