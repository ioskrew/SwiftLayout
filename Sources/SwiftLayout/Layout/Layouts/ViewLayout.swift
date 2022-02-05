//
//  ViewLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public struct ViewLayout<L>: LayoutViewContainable where L: LayoutContainable {
    var view: UIView
    var layoutable: L
    
    public var layouts: [Layout] {
        layoutable.layouts
    }
}
