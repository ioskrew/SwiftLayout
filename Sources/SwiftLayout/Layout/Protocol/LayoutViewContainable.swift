//
//  LayoutViewContainable.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

protocol LayoutViewContainable: LayoutContainable {
    var view: UIView { get }
}

extension LayoutViewContainable {
    public func attachSuperview(_ superview: UIView?) {
        superview?.addSubview(self.view)
        for layout in layouts {
            layout.attachSuperview(self.view)
        }
    }
    public func detachFromSuperview(_ superview: UIView?) {
        if let superview = superview, self.view.superview == superview {
            self.view.removeFromSuperview()
        }
        for layout in layouts {
            layout.detachFromSuperview(self.view)
        }
    }
    
    public var hashable: AnyHashable {
        AnyHashable(layouts.map(\.hashable) + [self.view.hashable])
    }
}
