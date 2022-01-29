//
//  Layoutable.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

public protocol Layoutable {
    func moveToSuperlayoutable(_ layoutable: Layoutable) -> Layoutable
}

protocol ViewContainLayoutable: Layoutable {
    var view: UIView { get }
}
