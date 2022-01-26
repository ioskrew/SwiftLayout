//
//  LayoutVisualize.swift
//  
//
//  Created by maylee on 2022/01/26.
//

import Foundation
import UIKit

public protocol LayoutVisualize {
    
    var top: SwiftLayout.Element { get }
    
}

extension LayoutVisualize where Self: UIView {
    
    public var top: SwiftLayout.Element {
        SwiftLayout.Element(item: .view(self), attribute: .top)
    }
    
}
