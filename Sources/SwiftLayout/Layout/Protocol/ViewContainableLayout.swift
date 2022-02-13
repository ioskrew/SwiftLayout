//
//  ViewContainableLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol ViewContainable {
    var superview: UIView? { get }
    var view: UIView { get }
}

extension ViewContainable where Self: Layout {
    
    public func attachSuperview(_ superview: UIView?) {
        if let superview = superview {
            view.translatesAutoresizingMaskIntoConstraints = false
            superview.addSubview(view)
        }
        for layout in sublayouts {
            layout.attachSuperview(view)
        }
    }
    
}
