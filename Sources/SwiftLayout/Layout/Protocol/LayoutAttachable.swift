//
//  LayoutAttachable.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation
import UIKit

public protocol LayoutAttachable: Layout {
    func attachLayout(_ layout: LayoutAttachable)
    func addSubview(_ view: UIView)
    
    func constraints(with view: UIView) -> [NSLayoutConstraint]
}

extension LayoutAttachable {
    public func addSubview(_ view: UIView) {}
}

extension LayoutAttachable where Self: UIViewContainable {
    
    public func addSubview(_ view: UIView) {
        guard view.superview != self.view else { return }
        self.view.addSubview(view)
    }
    
}

extension LayoutAttachable where Self: UIViewContainable, Self: LayoutContainable {
    
    public func addSubview(_ view: UIView) {
        guard view.superview != self.view else { return }
        self.view.addSubview(view)
        for layout in layouts {
            addConstraint(layout.constraints(with: self.view))
        }
    }
    
}

extension LayoutAttachable where Self: LayoutContainable {
    
    public func attachLayout(_ layout: LayoutAttachable) {
        for sublayout in layouts {
            sublayout.attachLayout(layout)
        }
    }
    
}
