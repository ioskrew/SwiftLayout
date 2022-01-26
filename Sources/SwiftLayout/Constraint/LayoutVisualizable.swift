//
//  LayoutVisualize.swift
//  
//
//  Created by maylee on 2022/01/26.
//

import Foundation
import UIKit

public protocol LayoutVisualize {
    
    typealias Element = SwiftLayout.Element
    
    var top: Element { get }
    var bottom: Element { get }
    
}

extension LayoutVisualize where Self: UIView {
    
    public var top: Element { element(.top) }
    public var bottom: Element { element(.bottom) }
    
}
