//
//  ViewLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public struct ViewLayout<L>: ViewContainableLayout where L: ContainableLayout {
    internal(set) public var view: UIView
    var layoutable: L
    
    public var layouts: [Layout] {
        layoutable.layouts
    }
}
