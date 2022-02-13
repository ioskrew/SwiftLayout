//
//  ViewContainableLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol ViewContainable {
    var superview: UIView? { get set }
    var view: UIView { get }
    
    func updateSuperview(_ superview: UIView?)
}

extension ViewContainable where Self: Layout {
    
    public func prepareSuperview(_ superview: UIView?) {
        updateSuperview(superview)
        for layout in sublayouts {
            layout.prepareSuperview(view)
        }
    }
  
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
