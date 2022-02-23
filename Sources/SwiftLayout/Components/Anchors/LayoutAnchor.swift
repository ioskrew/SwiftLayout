//
//  LayoutAnchor.swift
//  
//
//  Created by oozoofrog on 2022/02/22.
//

import Foundation
import UIKit

public protocol LayoutAnchor {}
extension NSLayoutDimension: LayoutAnchor {}
extension NSLayoutXAxisAnchor: LayoutAnchor {}
extension NSLayoutYAxisAnchor: LayoutAnchor {}
