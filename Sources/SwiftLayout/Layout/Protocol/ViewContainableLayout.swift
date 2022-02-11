//
//  ViewContainableLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol ViewContainableLayout: ContainableLayout {
    var view: UIView? { get }
}

public extension ViewContainableLayout {
    
    func detachFromSuperview(_ superview: UIView?) {
        guard let view = self.view else { return }
        if let superview = superview, view.superview == superview {
            view.removeFromSuperview()
        }
        for layout in layouts {
            layout.detachFromSuperview(view)
        }
    }
    
    var hashable: AnyHashable {
        AnyHashable(layouts.map(\.hashable) + [self.view.hashable])
    }
}
