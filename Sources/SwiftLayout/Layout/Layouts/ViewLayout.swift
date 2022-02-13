//
//  ViewLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public final class ViewLayout: ViewContainable, Layout {
    
    internal init(view: UIView, sublayouts: [Layout]) {
        self.view = view
        self.sublayouts = sublayouts
    }
    
    public weak var superview: UIView?
    public let view: UIView
    public let sublayouts: [Layout]
    
    public func prepareSuperview(_ superview: UIView?) {
        self.superview = superview
        for layout in sublayouts {
            layout.prepareSuperview(view)
        }
    }
  
}

extension ViewLayout: LayoutFlattening {}
