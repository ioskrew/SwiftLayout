//
//  InternalLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/11.
//

import Foundation
import UIKit

protocol LayoutFlattening {
    
    var layoutViews: [UIView] { get }
    var layoutConstraints: [NSLayoutConstraint] { get }
    
}
