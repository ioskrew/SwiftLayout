//
//  UIView+Layout.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation
import UIKit

extension UIView: LayoutAttachable {
    
    public func active() -> AnyDeactivatable {
        return AnyDeactivatable()
    }
    
    public func deactive() {
        removeFromSuperview()
    }
    
    public func attachLayout(_ layout: LayoutAttachable) {
        translatesAutoresizingMaskIntoConstraints = false
        layout.addSubview(self)
    }
    
    public var equation: AnyHashable {
        AnyHashable(self)
    }
}

public extension Layout where Self: UIView {
    
    @discardableResult
    func callAsFunction<Sub>(@LayoutBuilder _ content: () -> Sub) -> SuperSubLayout<Self, Sub> where Sub: Layout {
        SuperSubLayout<Self, Sub>(superview: self, subLayout: content())
    }
    
}

