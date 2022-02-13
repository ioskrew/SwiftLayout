//
//  ViewContainableLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol ViewContainableLayout: Layout {
    var view: UIView { get }
}
