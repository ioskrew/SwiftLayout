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
}

extension LayoutAttachable {
    public func addSubview(_ view: UIView) {}
}

extension LayoutAttachable where Self: UIViewContainable {
    
    public func addSubview(_ view: UIView) {
        self.view.addSubview(view)
    }
    
}

extension LayoutAttachable where Self: LayoutContainable {
    
    public func attachLayout(_ layout: LayoutAttachable) {
        layouts.forEach({ sublayout in
            sublayout.attachLayout(layout)
        })
    }
    
}
