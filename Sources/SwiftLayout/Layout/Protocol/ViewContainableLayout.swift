//
//  ViewContainableLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol ViewContainableLayout: ContainableLayout {
    var view: UIView { get }
}

extension ViewContainableLayout {
    public func detachFromSuperview() {
        view.removeFromSuperview()
        for layout in layouts {
            layout.detachFromSuperview()
        }
    }
}
