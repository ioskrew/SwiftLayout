//
//  LayoutConstraintAttachable.swift
//  
//
//  Created by oozoofrog on 2022/02/03.
//

import Foundation
import UIKit

public protocol LayoutConstraintAttachable: LayoutAttachable {
    var guide: UILayoutGuide? { get }
    var view: UIView? { get }
}
